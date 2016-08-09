package com.bit101.components.controlList 
{
	/**
	 * ...
	 * @author ...
	 * 用于ControlList的参数设置.翻页模式
	 */
	public class ControlAlignmentParam_ForPageMode 
	{		
		public var m_marginLeft:int;
		public var m_marginRight:int;		
		public var m_class:Class;	//控件类型
		public var m_onscrollTobothEndFun:Function;
		
		public var m_intervalH:int;	//在x轴方向，2个相邻控件的距离
		public var m_intervalV:int;	//在y轴方向，2个相邻控件的距离
		public var m_numColumn:int;	//在一页中，可以显示的列数		
		public var m_numRow:int;	//在一页中，可以显示的行数	
		public var m_width:int;		//子控件的宽度
		public var m_height:int;	//子控件的高度		
		
		public var m_dataParam:Object;
		
	}

}