package com.pblabs.engine.resource 
{    
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import com.util.PBUtil;
	//import flash.events.Event;
    import flash.system.ApplicationDomain;
	//import flash.utils.Dictionary;
	import flash.display.MovieClip;
	import flash.display.Sprite;

    [EditorData(extensions="swf")]

    /**
     * This is a Resource subclass for SWF files. It makes it simpler
     * to load the files, and to get assets out from inside them.
	 * 这个类是加载 MovieClip swc swf 类 
     */
    public class SWFResource extends Resource
    {
		public function SWFResource()
		{
			m_swfAid = new SWFAid();
		}
		
        public function get clip():MovieClip 
        {
            return _clip;
        }

        public function get appDomain():ApplicationDomain 
        {
            return _appDomain; 
        }

        /**
         * Gets a new instance of the specified exported class contained in the SWF.
         * Returns a null reference if the exported name is not found in the loaded ApplicationDomain.
         *
         * @param name The fully qualified name of the exported class.
		 * @param fromcache: 是否从缓存中取 BitmapData 
         */
        public function getExportedAsset(name:String, fromcache:Boolean = false, mode:uint = 0):Object 
        {
            if (null == _appDomain) 
                throw new Error("_appDomain not initialized; isLoaded="+isLoaded+" filename="+filename);

            //var assetClass:Class = getAssetClass(name);
			var assetClass:Class;
			var destname:String;
            //if (assetClass != null)
			//{
				if (!fromcache)
				{
					assetClass = getAssetClass(name);
					if (assetClass != null)
					{
						return new assetClass();
					}
				}
				else if(mode == EntityCValue.FLPOrig)
				{
					if (!m_swfAid.m_class2BitmapDataDic[name])
					{
						assetClass = getAssetClass(name);
						if (assetClass != null)
						{
							m_swfAid.m_class2BitmapDataDic[name] = new assetClass();
						}
						else
						{
							var info:String = "getExportedAsset error: classname : " + name + "filename: " + this.filename;
							DebugBox.info(info);
							//throw new Event(info);
						}
					}
					return m_swfAid.m_class2BitmapDataDic[name];
				}
				else if (mode == EntityCValue.FLPX)
				{
					destname = name + "-x";
					if (!m_swfAid.m_class2BitmapDataDic[destname])
					{
						if (m_swfAid.m_class2BitmapDataDic[name])
						{
							m_swfAid.m_class2BitmapDataDic[destname] = PBUtil.flipBitmapDataHori(m_swfAid.m_class2BitmapDataDic[name]);
						}
						else
						{
							assetClass = getAssetClass(name);
							if (assetClass != null)
							{
								m_swfAid.m_class2BitmapDataDic[destname] = PBUtil.flipBitmapDataHori(new assetClass());
							}
							else
							{								
								DebugBox.info("getExportedAsset error: classname : " + name + "filename: " + this.filename);								
							}
						}
					}
					
					return m_swfAid.m_class2BitmapDataDic[destname];
				}
				else if (mode == EntityCValue.FLPY)
				{
					destname = name + "-y";
					if (!m_swfAid.m_class2BitmapDataDic[destname])
					{
						if (m_swfAid.m_class2BitmapDataDic[name])
						{
							m_swfAid.m_class2BitmapDataDic[destname] = PBUtil.flipBitmapDataHori(m_swfAid.m_class2BitmapDataDic[name]);
						}
						else
						{
							assetClass = getAssetClass(name);
							if (assetClass != null)
							{
								m_swfAid.m_class2BitmapDataDic[destname] = PBUtil.flipBitmapDataHori(new assetClass());
							}
							else
							{								
								DebugBox.info("getExportedAsset error: classname : " + name + "filename: " + this.filename);								
							}
						}
					}
					
					return m_swfAid.m_class2BitmapDataDic[destname];
				}

				return null;
			//}
            //else
			//{
            //    return null;
			//}
        }

        /**
         * Gets a Class instance for the specified exported class name in the SWF.
         * Returns a null reference if the exported name is not found in the loaded ApplicationDomain.
         *
         * @param name The fully qualified name of the exported class.
         */
        public function getAssetClass(name:String):Class 
        {           
            if (null == _appDomain) 
                throw new Error("not initialized");

            if (_appDomain.hasDefinition(name))
                return _appDomain.getDefinition(name) as Class;
            else
                return null;
        }

		public function hasAssetClass(name:String):Boolean
		{
			if (null == _appDomain) 
                throw new Error("not initialized");
			return _appDomain.hasDefinition(name);
		}
        /**
         * Recursively searches all child clips for the maximum frame count.
         */
        public function findMaxFrames(parent:MovieClip, currentMax:int):int
        {
            for (var i:int=0; i < parent.numChildren; i++)
            {
                var mc:MovieClip = parent.getChildAt(i) as MovieClip;
                if(!mc)
                    continue;

                currentMax = Math.max(currentMax, mc.totalFrames);            

                findMaxFrames(mc, currentMax);
            }

            return currentMax;
        }


        /**
         * Recursively advances all child clips to the specified frame.
         * If the child does not have a frame at the position, it is skipped.
         */
        public function advanceChildClips(parent:MovieClip, frame:int):void
        {
            for (var j:int=0; j<parent.numChildren; j++)
            {
                var mc:MovieClip = parent.getChildAt(j) as MovieClip;
                if(!mc)
                    continue;

                if (mc.totalFrames >= frame)
                    mc.gotoAndStop(frame);
                else
                    mc.gotoAndStop(mc.totalFrames);

                advanceChildClips(mc, frame);
            }
        }

        override public function initialize(data:*):void
        {
			// 注意之前加载的 swf 是先通过二进制加载到内存，然后才初始化的，因此加载进来后 data 是bytearray，但是现在是用 Loader 直接加载 swf ，因此这个时候 data 是 MovieClip 类型
			// MovieClip 单独一个类，不走这个类了
            // Directly load embedded resources if they gave us a MovieClip.
            //if(data is MovieClip)
            //{
                //onContentReady(data);
                //onLoadComplete();
                //return;
            //}
            
            // Otherwise it must be a ByteArray, pass it over to the normal path.
            //super.initialize(data);
			
			// 如果是有文档类的，那么 data 类型就是文档类，如果没有文档类，那么 data 就是 MovieClip 类型
			onContentReady(data);
			onLoadComplete();
        }

        /**
         * @inheritDoc
         */
        override protected function onContentReady(content:*):Boolean 
        {
            if(content is MovieClip)
                _clip = content as MovieClip;
			else if (content is Sprite)
				_sprite = content as Sprite;

            // Get the app domain...
            if (resourceLoader && resourceLoader.contentLoaderInfo)
                _appDomain = resourceLoader.contentLoaderInfo.applicationDomain;
            else if(content && content.loaderInfo)
                _appDomain = content.loaderInfo.applicationDomain;
            
            //return _clip != null;
			if(content is MovieClip)
                return _clip != null;
			else if (content is Sprite)
				return _sprite != null;
			
			//return false;
			return _clip != null || _sprite != null;
        }
		
		public function get content():Sprite
		{
			return _sprite;
		}
		
		override public function dispose():void
		{
			m_swfAid.dispose();
			m_swfAid = null;
			_clip = null;
			_appDomain = null;
			_sprite = null;
			
			super.dispose();
		}

        private var _clip:MovieClip;
        private var _appDomain:ApplicationDomain;
		
		protected var _sprite:Sprite;	// 父类是 Sprite 的资源，尤其是模块 
		
		// BitmapData 类优化，只保存一个 BitmapData ，公用这个 BitmapData 。
		protected var m_swfAid:SWFAid;
    }
}