package com.bit101.components.controlList 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ControlAlignmentParam extends ControlAlignmentParamBase
	{		
		
		public var m_intervalH:int;	//在x轴方向，2个相邻控件的距离
		public var m_intervalV:int;	//在y轴方向，2个相邻控件的距离
		public var m_numColumn:int;	//在一页中，可以显示的列数		
		public var m_width:int;		//子控件的宽度
		public var m_height:int;	//子控件的高度
		public var m_parentHeight:int;	//父控件的高度
		
		public var m_bAutoHeight:Boolean;	//自动调整高度	
		public var m_needScroll:Boolean;	//false - 不显示滚动条
		public var m_scrollType:uint = 0; 	// 滚动类型 0 : 滚动条翻页，保证最后一页是满的， 1: 滚动一页
	}

}