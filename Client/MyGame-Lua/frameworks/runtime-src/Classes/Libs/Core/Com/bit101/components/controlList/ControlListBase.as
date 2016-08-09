package com.bit101.components.controlList 
{
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.Panel;
	//import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ControlListBase extends PanelContainer 
	{
		protected var m_container:Panel;
		protected var m_controls:Vector.<CtrolComponentBase>;
		protected var m_datas:Array;
		protected var m_iSelectedIndex:int = -1;
		protected var m_scrollPos:int;
		protected var m_bInitSubCtrlOnShow:Boolean;	//当子控件第一次显示的时候再初始化
		public function ControlListBase(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_controls = new Vector.<CtrolComponentBase>;
			m_container = new Panel(this);
			
		}
		
		override public function draw():void 
		{
			super.draw();
			this.drawRectBG();
		}
		public function findCtrl(funFind:Function, param:Object = null):CtrolComponentBase
		{
			var ret:CtrolComponentBase;
			for each(ret in m_controls)
			{
				if (funFind(ret.data,param) == true)
				{
					return ret;
				}
			}
			return null;
		}
		public function findCtrolIndex(funFind:Function, param:Object = null):int
		{
			var i:int;
			var ret:CtrolComponentBase;
			var count:int = m_controls.length;
			for (i = 0; i < count; i++)
			{
				if (funFind(m_controls[i].data,param) == true)
				{
					return i;
				}
			}
			return -1;
		}
		public function findCtrolIndexByData(data:Object):int
		{
			var i:int;
			var ret:CtrolComponentBase;
			var count:int = m_controls.length;
			for (i = 0; i < count; i++)
			{
				if (m_controls[i].data == data)
				{
					return i;
				}
			}
			return -1;
		}
		//通过数据，获得包含此数据的控件
		public function getCtrl(data:Object):CtrolComponentBase
		{
			var ret:CtrolComponentBase;
			for each(ret in m_controls)
			{
				if (ret.data == data)
				{
					return ret;
				}
			}
			return null;
		}
		//设置被选择的项
		//index表示子控件的索引。zero-based
		public function setSeleced(index:int):void
		{
			if (m_iSelectedIndex == index)
			{
				return;
			}
			if (m_iSelectedIndex >= 0 && m_iSelectedIndex < m_controls.length)
			{
				m_controls[m_iSelectedIndex].onNotSelected();
			}
			if (index >= 0 && index < m_controls.length)
			{
				m_controls[index].onSelected();
			}
			m_iSelectedIndex = index;
			dispatchEvent(new Event(Event.SELECT));
		}
		protected function onItemClik(event:MouseEvent):void
		{
			var ctrol:CtrolComponentBase = event.currentTarget as CtrolComponentBase;
			if (ctrol == null)
			{
				//这里这么做，因为event.currentTarget可能是CtrolVHeightComponent对象的孩子
				var i:int;
				var count:int = m_controls.length;
				for (i = 0; i < count; i++)
				{
					if (m_controls[i].contains(event.currentTarget as DisplayObject))
					{
						ctrol = m_controls[i];
						break;
					}
				}
			}
			if (ctrol == null || ctrol.canSelected == false)
			{
				return;
			}
			var index:int = m_controls.indexOf(ctrol);
			setSeleced(index);
			
		}
		
		public function update():void
		{
			var i:int;
			var count:int = m_controls.length;
			for (i = 0; i < count; i++)
			{
				m_controls[i].update();
			}
		}
		
		
		public function deleteData(index:int):void
		{
			if (index >= m_controls.length)
			{
				return;
			}
			var delCtrol:CtrolComponentBase = m_controls[index];
			delCtrol.removeEventListener(MouseEvent.CLICK, onItemClik);
			m_controls.splice(index, 1);
			this.m_container.removeChild(delCtrol);
			delCtrol.dispose();
			
			adjustAllPos();
		}
		protected function adjustAllPos():void
		{
			
		}
		public function deleteDataByCtrol(delCtrol:CtrolComponentBase):void
		{
			var i:int = m_controls.indexOf(delCtrol);
			if (i >= 0)
			{
				deleteData(i);
			}
		}
		public function execFun(fun:Function, param:Object = null):void
		{
			var i:int;
			var count:int = m_controls.length;
			for (i = 0; i < count; i++)
			{
				fun(m_controls[i], param);
			}			
		}
		public function getControlByIndex(index:int):CtrolComponentBase
		{
			if (index >= 0 && index < m_controls.length)
			{
				return m_controls[index];
			}
			return null;
		}
		public function getControlSelected():CtrolComponentBase
		{
			if (m_iSelectedIndex >= 0 && m_iSelectedIndex < m_controls.length)
			{
				return m_controls[m_iSelectedIndex];
			}
			return null;
		}
		
		//查询被选中的控件里的数据
		public function getDataSelected():Object
		{
			if (m_iSelectedIndex >= 0 && m_iSelectedIndex < m_controls.length)
			{
				return m_controls[m_iSelectedIndex].data;
			}
			return null;
		}
		public function get controlList():Vector.<CtrolComponentBase>
		{
			return m_controls;
		}
		protected function updatePos():void
		{			
			m_container.y = - m_scrollPos;
			if (m_bInitSubCtrlOnShow)
			{
				processCtrlFirstShow();
			}
		}
				
		public function get scrollPos():Number
		{
			return m_scrollPos;
		}
		public function canToPriLine():Boolean
		{
			return m_scrollPos > 0;
		}
		//返回值 -1:没有任何控件被选中，其它值表示控件的索引(zero-based)
		public function get selectedIndex():int
		{
			return m_iSelectedIndex;
		}
		
		public function set bInitSubCtrlOnShow(b:Boolean):void
		{
			m_bInitSubCtrlOnShow = b;
		}
		
		protected function processCtrlFirstShow():void
		{
			
		}
	}

}