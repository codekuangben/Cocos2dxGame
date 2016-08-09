package com.bit101.components.comboBox 
{
	/**
	 * ...
	 * @author 
	 */
	public class ComboBoxParam 
	{
		public var m_listItemHeight:int;
		public var m_ListWidth:int;
		public var m_listItemClass:Class;
		public var m_funIgoreMouseUpOnStageClick:Function;	//鼠标单击时，判断是否关闭列表  igoreMouseUpOnStageClick(event:MouseEvent):Boolean
		public function ComboBoxParam() 
		{
			m_listItemHeight = 20;
		}
		
	}

}