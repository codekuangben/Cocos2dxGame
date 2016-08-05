package com.bit101.components.controlList 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ControlVHeightAlignmentParam  extends ControlAlignmentParamBase
	{		
		public var m_bCreateScrollBar:Boolean;		
		public var m_intervalV:int;	//在y轴方向，2个相邻控件的距离
		public var m_width:int;		//子控件的宽度
		public var m_height:int;		//子控件的高度，当m_height不等于零时，表示每个子控件的高度是固定的
		public var m_heightList:int; //父控件的高度，即ControlListVHeight
		public var m_scrollType:uint = 0; 	// 滚动类型 0 : 滚动条翻页，保证最后一页是满的， 1: 滚动一页, 2: 自动调整高度		
	}

}