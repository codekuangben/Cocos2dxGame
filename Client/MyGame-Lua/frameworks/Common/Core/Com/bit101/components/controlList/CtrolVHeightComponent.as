package com.bit101.components.controlList 
{	
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class CtrolVHeightComponent extends CtrolComponentBase 
	{		
		protected var m_list:ControlListVHeight;
		public var m_relativeY:int;
		public function set list(list:ControlListVHeight):void
		{
			m_list = list;
		}
		
		public function isScrollVisible():Boolean
		{
			return m_list.isCtrlVisibleForScroll(this);
		}
	}

}