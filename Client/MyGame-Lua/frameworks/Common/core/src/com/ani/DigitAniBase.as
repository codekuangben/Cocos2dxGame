package com.ani 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.gskinner.motion.GTween;
	import com.util.UtilXML;
	
	public class DigitAniBase 
	{
		protected var m_id:int;
		protected var m_bRun:Boolean;
		protected var m_onEnd:Function;
		protected var m_sp:Object;	
		
		protected function onComplete(tween:GTween):void 
		{
			onAniEnd();
		}
		
		protected function onAniEnd():void
		{
			m_bRun = false;
			if (m_onEnd != null)
			{
				m_onEnd();				
			}
		}
		
		public function dispose():void 
		{
			m_onEnd = null;
		}
		public function set sprite(sp:Object):void
		{
			m_sp = sp;
		}
		public function begin():void
		{
			m_bRun = true;
		}
		public function set onEnd(fun:Function):void
		{
			m_onEnd = fun;
		}
		public function get bRun():Boolean
		{
			return m_bRun;
		}
		public function stop():void
		{
			m_bRun = false;
		}
		public function parseXML(xml:XML):void
		{
			m_id = UtilXML.attributeIntValue(xml, "id");
		}
		
		public function getAniByID(id:int):DigitAniBase
		{
			if (m_id == id)
			{
				return this;
			}
			return null;
		}
	}

}