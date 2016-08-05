package com.bit101.components.controlList 
{
	import com.bit101.components.PanelContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class CtrolComponentBase extends PanelContainer 
	{
		protected var m_data:Object;
		protected var m_index:int;	//表示第几个对象，zero-based
		protected var m_select:Boolean;
		protected var m_bFirst:Boolean;	//true-本对象是列表中的第一个
		protected var m_bLast:Boolean;	//true-本对象是列表中的最后一个
		protected var m_canSelected:Boolean;	//true -表示该项可以被选择
		protected var m_bHasShow:Boolean;	//true - 在调用setData之后，本控件已经显示出来过了
		public function CtrolComponentBase(param:Object = null) 
		{
			m_canSelected = true;
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			super.dispose();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{			
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);			
			onOver();						
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);			
			onOut();
		}
		public function setData(_data:Object):void
		{
			m_bHasShow = false;
			m_data = _data;
		}
		
		public function init():void
		{
			
		}
		public function get data():Object
		{
			return m_data;
		}
		
		public function set index(i:int):void
		{
			m_index = i;
		}
		public function get index():int
		{
			return m_index;
		}
		public function onOver():void
		{
			
		}
		public function onOut():void
		{
			
		}
		
		public function onSelected():void
		{
			m_select = true;
		}
		public function onNotSelected():void
		{
			m_select = false;
		}
		public function get select():Boolean
		{
			return m_select;
		}
		
		public function get canSelected():Boolean
		{
			return m_canSelected;
		}
		public function update():void
		{
			
		}	
		public function setFirstAndLastFlag(bFist:Boolean, bLast:Boolean, index:int):void
		{
			m_bFirst = bFist;
			m_bLast = bLast;
			m_index = index;
		}
		
		public function get bHasShow():Boolean
		{
			return m_bHasShow;
		}
		//在调用setData之后，本空间第一次显示出来
		public function onFirstShow():void
		{
			m_bHasShow = true;
			init()
		}
	}

}