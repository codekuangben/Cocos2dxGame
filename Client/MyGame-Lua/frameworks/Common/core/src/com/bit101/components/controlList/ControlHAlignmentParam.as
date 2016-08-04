package com.bit101.components.controlList 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ControlHAlignmentParam  extends ControlAlignmentParamBase
	{		
		public var m_intervalH:int;	//在x轴方向，2个相邻控件的距离
		public var m_height:int;	//子控件的高度
		public var m_widthList:int; //父控件的宽度
		
		override public function copy(param:ControlAlignmentParamBase):void 
		{
			super.copy(param);
			var paramDest:ControlHAlignmentParam = param as ControlHAlignmentParam;
			paramDest.m_intervalH = this.m_intervalH;
			paramDest.m_height = this.m_height;
			paramDest.m_widthList = this.m_widthList;
		}
		
	}

}