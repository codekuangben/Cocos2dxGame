package com.bit101.components 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.DisplayObjectContainer;
	public class PanelParam extends PanelContainer 
	{
		private var m_param1:int;
		private var m_param2:int;
		public function PanelParam(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent, xpos, ypos);
		}
		
		public function set param1(param:int):void
		{
			m_param1 = param;
		}
		public function get param1():int
		{
			return m_param1;
		}
		
		public function set param2(param:int):void
		{
			m_param2 = param;
		}
		public function get param2():int
		{
			return m_param2;
		}
	}

}