package com.ani 
{
	import com.ani.DigitAniBase;
	import com.gskinner.motion.GTween;
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class AniPause extends DigitAniBase 
	{
		private var m_gtWeen:GTween;	
		private var m_delay:Number = 0;
		public var t:Number = 0;
		public function AniPause() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.paused = true;
			m_gtWeen.autoPlay = false;			
			m_gtWeen.useFrames = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;
			m_gtWeen.target = this;
			m_gtWeen.setValue("t", 1);
		}
		
		public function set delay(t:Number):void
		{
			m_delay = t;
		}
		override public function begin():void
		{
			super.begin();
			m_gtWeen.duration = m_delay;
			m_gtWeen.paused = false;
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
		
		public function set useFrames(b:Boolean):void
		{
			m_gtWeen.useFrames = b;
		}
		override public function dispose():void 
		{
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen = null;
			super.dispose();
		}
		
		/*通过xml进行参数设置
		 * <AniPause delay="1" useFrames="0"/>	
		 * 如果speed与duraton都设置，则duration无效
		 */
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			delay = UtilXML.attributeIntValue(xml, "delay");
			useFrames = UtilXML.attributeAsBoolean(xml, "useFrames");
		}
	}

}