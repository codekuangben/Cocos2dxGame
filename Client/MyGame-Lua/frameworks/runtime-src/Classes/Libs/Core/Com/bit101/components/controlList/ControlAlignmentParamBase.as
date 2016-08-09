package com.bit101.components.controlList 
{
	/**
	 * ...
	 * @author 
	 */
	public class ControlAlignmentParamBase 
	{		
		public static const ScrollType_LastPageFull:int = 0;	//滚动条翻页，保证最后一页是满的
		public static const ScrollType_Normal:int = 1;	//正常情况
		public static const ScrollType_AutoHeight:int = 2;	//自动调整母控件的高度
		
		public var m_marginLeft:int;
		public var m_marginRight:int;
		public var m_marginTop:int;
		public var m_marginBottom:int;
		public var m_lineSize:int;	//鼠标单击滚动条上下按钮时，每次移动这么多
		public var m_class:Class;	//控件类型
		public var m_onscrollTobothEndFun:Function;
		
		public var m_dataParam:Object;
		
		public function copy(param:ControlAlignmentParamBase):void
		{
			param.m_marginLeft = this.m_marginLeft;
			param.m_marginRight = this.m_marginRight;
			param.m_marginTop = this.m_marginTop;
			param.m_marginBottom = this.m_marginBottom;
			param.m_lineSize = this.m_lineSize;
			param.m_class = this.m_class;
			param.m_onscrollTobothEndFun = this.m_onscrollTobothEndFun;
			param.m_dataParam = this.m_dataParam;
		}
	
		
	}

}