package com.bit101.components.controlList.controlList_VerticalAlign 
{
	import com.bit101.components.controlList.ControlAlignmentParamBase;
	/**
	 * ...
	 * @author 
	 */
	public class ControlList_VerticalAlign_Param extends ControlAlignmentParamBase 
	{
		public var m_width:int;		//子控件的宽度
		public var m_height:int;		//子控件的高度
		public var m_intervalH:int;	//在x轴方向，2个相邻控件的距离
		public var m_intervalV:int;	//在y轴方向，2个相邻控件的距离
		public var m_numColum:int;		//子控件的列数	//在一页中，显示的列数
		public var m_numRow:int;		//子控件的行数	
		
		public function ControlList_VerticalAlign_Param() 
		{
			
		}
		override public function copy(paramBase:ControlAlignmentParamBase):void
		{
			var param:ControlList_VerticalAlign_Param = paramBase as ControlList_VerticalAlign_Param;
			param.m_width = m_width;
			param.m_height = m_height;
			param.m_intervalH = m_intervalH;
			param.m_intervalV = m_intervalV;
			param.m_numRow = m_numRow;		
			param.m_numColum = m_numColum;
			super.copy(paramBase);
		}
	}

}