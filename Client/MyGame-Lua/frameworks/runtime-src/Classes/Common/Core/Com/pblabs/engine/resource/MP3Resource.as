package com.pblabs.engine.resource
{
    //import flash.events.Event;
    //import flash.events.IOErrorEvent;
    import flash.media.Sound;
    //import flash.net.URLRequest;
    
    [EditorData(extensions="mp3")]
    
    /**
     * Load Sounds from MP3s using Flash Player's built in MP3 loading code.
     */
    public class MP3Resource extends SoundResource
    {
        /**
         * The loaded sound.
         */
        protected var _soundObject:Sound = null;
        
        override public function get soundObject() : Sound
        {
            return _soundObject;
        }
        
        override public function initialize(d:*):void
        {
            _soundObject = d;
            onLoadComplete();
        }
        
        /**
         * @inheritDoc
         */
        override protected function onContentReady(content:*):Boolean 
        {
            return soundObject != null;
        }
		
		// 基本数据保存地方
		public var category:String="sfx";
		public	var pan:Number=0.0;
		public var loopCount:int=0;
		public var startDelay:Number=0.0;
    }
}