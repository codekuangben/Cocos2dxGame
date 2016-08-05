package com.ani 
{
	/**
	 * ...
	 * @author 
	 */
	import com.gskinner.motion.GTween;
	import com.hurlant.util.der.Integer;
	import com.util.KeyValueParse;
	import com.util.UtilXML;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	public class AniPropertys extends DigitAniBase 
	{
		protected var m_ease:Function;
		protected var m_duration:Number;
		private var m_gtWeen:GTween;
		public var data:Object;
		private var m_timer:Timer;
		private var m_delay:Number=0;
		public function AniPropertys() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.paused = true;
			m_gtWeen.autoPlay = false;			
			m_gtWeen.useFrames = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;		
			
		}
		public function resetValues(value:Object):void
		{
			m_gtWeen.resetValues(value);
		}
		public function set repeatCount(t:int):void
		{
			m_gtWeen.repeatCount = t;
		}
		
		public function set duration(t:Number):void
		{
			m_duration = t;
		}
		public function set delay(t:Number):void
		{
			m_delay = t;
		}
		public function set useFrames(b:Boolean):void
		{
			m_gtWeen.useFrames = b;
		}
		public function set ease(ease:Function):void
		{
			m_ease = ease;
		}
		
		public function set reflect(b:Boolean):void
		{
			m_gtWeen.reflect = b;
		}
		override public function dispose():void 
		{
			super.dispose();
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen = null;
			if (m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer = null;
			}
		}
		override public function begin():void
		{
			super.begin();
			if (m_delay > 0)
			{
				if (m_timer == null)
				{
					m_timer = new Timer(m_delay*1000);
					m_timer.repeatCount = 1;
					m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				}
				
				m_timer.start();
				return;
			}
			beginEx();
		}
		
		
		private function beginEx():void
		{
			m_gtWeen.target = this.m_sp;
			if (m_ease != null)
			{
				m_gtWeen.ease = m_ease;
			}
			m_gtWeen.duration = m_duration;
			m_gtWeen.init();		
			m_gtWeen.beginning();
			m_gtWeen.paused= false;
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
		
		protected function onTimer(e:TimerEvent):void
		{
			beginEx();		
		}
		
		public function end():void
		{
			m_gtWeen.paused = true;
		}
		
		/*通过xml进行参数设置
		 * <AniPropertys attributes="alpha=1" duration="" ease="EASE_Exponential_easeOut" />
		 * 如果speed与duraton都设置，则duration无效
		 */
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			var str:String = UtilXML.attributeValue(xml, "attributes");
			var parse:KeyValueParse = new KeyValueParse();
			parse.parse(str);
			var dic:Dictionary = parse.dic;
			var values:Object = new Object();
			for(str in dic)
			{
				values[str] = parse.getNumberValue(str);
			}
			resetValues(values);
			duration = UtilXML.attributeIntValue(xml, "duration");			
			useFrames = UtilXML.attributeAsBoolean(xml, "useFrames");
			str = UtilXML.attributeValue(xml, "ease");
			if (str)
			{
				ease = AniDef.s_getEaseFunByName(str);
			}
		}
	}

}