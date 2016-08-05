/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.sound
{
    import com.pblabs.engine.core.ITickedObject;
    import com.pblabs.engine.debug.Logger;
    import com.pblabs.engine.resource.MP3Resource;
    import com.pblabs.engine.resource.ResourceEvent;
    import com.pblabs.engine.resource.SoundResource;
    
    import common.Context;
    
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    
    /**
     * This class implements the ISoundManager interface. See ISoundManager
     * for full documentation.
     * 
     * @see ISoundManager See ISoundManager for full documentation.
     */
    public class SoundManager implements ISoundManager, ITickedObject
    {
        public static const MUSIC_MIXER_CATEGORY:String = "music";
        public static const SFX_MIXER_CATEGORY:String = "sfx";
        
        public var maxConcurrentSounds:int = 5;

        protected var playingSounds:Array = [];
        protected var categories:Object = {};
        protected var rootCategory:SoundCategory = new SoundCategory();
        protected var cachedSounds:Object = { };
		// KBEN: 
		protected var m_context:Context;
        
        public function SoundManager(context:Context)
        {
			m_context = context;
            createCategory(MUSIC_MIXER_CATEGORY);
            createCategory(SFX_MIXER_CATEGORY);
        }
        
        public function play(sound:*, category:String="sfx", pan:Number=0.0, loopCount:int=0, startDelay:Number=0.0, resourceType:Class=null):SoundHandle
        {
            // Cap sound playback.
            if(playingSounds.length > maxConcurrentSounds)
            {
                return null;
            }
            
			var fullpath:String;
            // Infer type of sound, and get the Sound object.
            var actualSound:Sound = null;
            if(sound is Sound)
                actualSound = sound as Sound;
            else if(sound is SoundResource)
                actualSound = (sound as SoundResource).soundObject;
            else if(sound is String)
            {
				fullpath = "asset/scene/sound/" + sound;
                // Check if it is a known loaded sound, if so, then get the resource
                // and play that.
				// 如果这个资源已经在播放,再次播放只能重新播放这个资源,也合理也不合理
				// bug: 这个地方有点问题,如果这个 music 已经在 playingSounds 中并且在播放,是不是应该直接就用 playingSounds 里面的呢,因为重新播放也会对已有的那个有影响
                if(cachedSounds[fullpath])
				{
					// 说明这个音乐可能在播放,删除正在播放的音乐
					//var idx:int = 0;
					//while(idx < playingSounds.length)
					//{
					//	if(playingSounds[idx].m_soundFileName == fullpath)
					//	{
					//		(playingSounds[idx] as SoundHandle).stop();
					//		break
					//	}
					//	++idx;
					//}
					
                    actualSound = (cachedSounds[fullpath] as SoundResource).soundObject;
				}
                else
                {
                    // Make sure we have a ResourceType
                    if (!resourceType)
                        resourceType = MP3Resource;
                    
                    // Otherwise queue the resource and play it when it is loaded.
                    //m_context.m_resMgr.load(sound, resourceType, function(r:*):void
                    //{
                        //cachedSounds[sound] = r;
                        //play(r as SoundResource, category, pan, loopCount, startDelay);
                    //});
					
					var snd:MP3Resource = m_context.m_resMgr.load(fullpath, resourceType, onSoundLoaded, onSoundFailed) as MP3Resource;
					snd.category = category;
					snd.pan = pan;
					snd.loopCount = loopCount;
					snd.startDelay = startDelay;
                    
                    return null;
                }
            }
            else
            {
                throw new Error("Parameter sound is of unexpected type. Should be Sound, SoundResource, or String.");
            }
            
            // Great, so set up the SoundHandle, start it, and return it.
            var sh:SoundHandle = new SoundHandle(this, actualSound, category, pan, loopCount, startDelay);
			// 保存一下音乐路径
			// bug: 如果是从 cachedSounds 中取到的声音,这个时候 sound 是一个 String 类型
			if(sound is String)
			{
				sh.m_soundFileName = fullpath;
			}
			else
			{
				sh.m_soundFileName = sound.filename;
			}

            // Look up its category.
            var categoryRef:SoundCategory = categories[category] as SoundCategory;
            
            // Apply the category's transform to avoid transitory sound issues.
            if(categoryRef)
                sh.transform = SoundCategory.applyCategoriesToTransform(categoryRef.muted, sh.pan, sh.volume, categoryRef);            

            // Add to the list of playing sounds.
            playingSounds.push(sh);
           
            return sh;
        }

        public function stream(url:String, category:String = "sfx", pan:Number = 0.0, loopCount:int = 1, startDelay:Number = 0.0):SoundHandle
        {
            // Create a Sound from the URL.
            try
            {
                var ur:URLRequest = new URLRequest(url);
                var s:Sound = new Sound();
                s.addEventListener(IOErrorEvent.IO_ERROR, _handleStreamFailure, false, 0, true);
                s.load(ur);
            }
            catch(e:Error)
            {
                Logger.error(this, "stream", "Failed to stream Sound due to:" + e.toString() + "\n" + e.getStackTrace());
                return null;
            }
            
            // Great, so set up the SoundHandle, start it, and return it.
            var sh:SoundHandle = new SoundHandle(this, s, category, pan, loopCount, startDelay);            
            playingSounds.push(sh);
            return sh;
        }
        
        protected function _handleStreamFailure(e:IOErrorEvent):void
        {
            Logger.error(this, "_handleStreamFailure", "Error streaming sound: " + e.toString());
        }
        
        public function set muted(value:Boolean):void
        {
            rootCategory.muted = value;
            rootCategory.dirty = true;
        }
        
        public function get muted():Boolean
        {
            return rootCategory.muted;
        }
        
        public function set volume(value:Number):void
        {
            rootCategory.transform.volume = value;
            rootCategory.dirty = true;
        }
        
        public function get volume():Number
        {
            return rootCategory.transform.volume;
        }
        
        public function createCategory(category:String):void
        {
            categories[category] = new SoundCategory();
        }
        
        public function removeCategory(category:String):void
        {
            // TODO: Will tend to break if any sounds are using this category.
            categories[category] = null;
            delete categories[category];
        }
        
        public function setCategoryMuted(category:String, value:Boolean):void
        {
            categories[category].muted = value;
            categories[category].dirty = true;
        }
        
        public function getCategoryMuted(category:String):Boolean
        {
            return categories[category].muted;
        }
        
        public function setCategoryVolume(category:String, value:Number):void
        {
            categories[category].transform.volume = value;
            categories[category].dirty = true;
        }
        
        public function getCategoryVolume(category:String):Number
        {
            return categories[category].transform.volume;
        }
        
        public function setCategoryTransform(category:String, transform:SoundTransform):void
        {
            categories[category].transform = transform;
            categories[category].dirty = true;            
        }
        
        public function getCategoryTransform(category:String):SoundTransform
        {
            return categories[category].transform;
        }
        
        public function stopCategorySounds(category:String):void
        {
            for(var i:int=0; i<playingSounds.length; i++)
            {
                if((playingSounds[i] as SoundHandle).category != category)
                    continue;

                (playingSounds[i] as SoundHandle).stop();
                i--;
            }
        }

        public function stopAll():void
        {
            while(playingSounds.length)
			{
                (playingSounds[playingSounds.length-1] as SoundHandle).stop();
			}
        }
		
		// 停止某个音乐
		public function stop(sndname:String):void
		{
			var idx:int = 0;
			while(idx < playingSounds.length)
			{
				if(playingSounds[idx].m_soundFileName == "asset/scene/sound/" + sndname)
				{
					// 这行代码从 playingSounds[idx] 中删除
					(playingSounds[idx] as SoundHandle).stop();
					break;
				}
				++idx;
			}
		}
        
        public function getSoundHandlesInCategory(category:String, outArray:Array):void
        {
            for(var i:int=0; i<playingSounds.length; i++)
            {
                if((playingSounds[i] as SoundHandle).category != category)
                    continue;
                
                outArray.push(playingSounds[i]);
            }
        }
        
        internal function updateSounds():void
        {
            // Push dirty state down.
            if(!rootCategory.dirty)
            {
                // Each category must dirty its sounds.
                for(var categoryName:String in categories)
                {
                    // Skip clean.
                    if(categories[categoryName].dirty == false)
                        continue;
                    
                    // OK, mark appropriate sounds as dirty.
                    for(var j:int=0; j<playingSounds.length; j++)
                    {
                        var csh:SoundHandle = playingSounds[j] as SoundHandle;

                        if(csh.category != categoryName)
                            continue;
                        
                        csh.dirty = true;
                    }

                    // Clean the state.
                    categories[categoryName].dirty = false;
                }
            }
            else
            {
                // Root state is dirty, so we can clean all the categories.
                for(var categoryName2:String in categories)
                    categories[categoryName2].dirty = false;
            }
            
            // Now, update every dirty sound.
            for(var i:int=0; i<playingSounds.length; i++)
            {
                var curSoundHandle:SoundHandle = playingSounds[i] as SoundHandle;
                if(curSoundHandle.dirty == false && rootCategory.dirty == false)
                    continue;
                
                // It is dirty, so update the transform.
                if(curSoundHandle.channel)
                {
                    curSoundHandle.channel.soundTransform = 
                        SoundCategory.applyCategoriesToTransform(
                            false, curSoundHandle.pan, curSoundHandle.volume, 
                            rootCategory, categories[curSoundHandle.category]);                    
                }
                
                // Clean it.
                curSoundHandle.dirty = false;
            }
            
            // Clean the root category.
            rootCategory.dirty = false;
        }
        
        public function onTick(elapsed:Number):void
        {
            updateSounds();
        }
        
        internal function isInPlayingSounds(sh:SoundHandle):Boolean
        {
            var idx:int = playingSounds.indexOf(sh);
            return idx != -1;
        }

        internal function removeSoundHandle(sh:SoundHandle):void
        {
            var idx:int = playingSounds.indexOf(sh);
            if(idx == -1)
                throw new Error("Could not find in list of playing sounds!");
            playingSounds.splice(idx, 1);
        }
		
		protected function onSoundLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onSoundLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onSoundFailed);
			
			cachedSounds[event.resourceObject.filename] = event.resourceObject;
			var snd:MP3Resource = event.resourceObject as MP3Resource;
			play(event.resourceObject as SoundResource, snd.category, snd.pan, snd.loopCount, snd.startDelay);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
		}
		
		protected function onSoundFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onSoundLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onSoundFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed");
		}
    }
}