package com.bit101.utils 
{
	/**
	 * ...
	 * @author 
	 */
	import common.event.UIEvent;
	import flash.display.BitmapData;
	import com.bit101.components.Panel;
	import flash.display.DisplayObject;
	
	public class PanelDrawCreator 
	{
		private var m_bitmapData:BitmapData;
		private var m_container:Panel;
		private var m_width:int;
		private var m_height:int;
		private var m_bNotDisposeAfterDraw:Boolean;	//true - draw之后，不执行dipose操作
		private var m_isAllImageLoaded:Boolean;	
		private var m_funOnDraw:Function;
		
		public function PanelDrawCreator() 
		{
			m_container = new Panel();
		}
		
		public function beginAddCom(w:int,h:int):void
		{
			m_width = w;
			m_height = h;
			m_isAllImageLoaded = false;
		}
		
		public function endAddCom():void
		{
			//与beginAddCom相应，仅作"添加对象结束"标识
		}
		
		public function addDrawCom(sp:DisplayObject):void
		{
			m_container.addChild(sp);
		}
		
		public function endAdd():void
		{
			m_container.addEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
			m_container.beginCheckImageLoaded();
		}
		private function onAllImageLoaded(e:UIEvent):void
		{
			drawIt();
			this.m_container.removeEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
		}
		private function drawIt():void
		{
			m_bitmapData = new BitmapData(m_width, m_height, true, 0xffffff);
			m_bitmapData.draw(m_container);
			m_isAllImageLoaded = true;
			if (m_bNotDisposeAfterDraw==false)
			{
				m_container.dispose();
			}
			clearContainer();			
			
			if (m_funOnDraw!=null)
			{
				m_funOnDraw(this);
			}
			
		}
		protected function clearContainer():void
		{
			m_container.dispose();
			var i:int = m_container.numChildren - 1;
			while (i >= 0)
			{
				m_container.removeChildAt(i);
				i--;
			}			
		}
		public function set funOnDraw(fun:Function):void
		{
			m_funOnDraw = fun;			
		}
		
		public function setFilter(filters:Array):void
		{
			m_container.filters = filters;
		}
		public function get bitmapData():BitmapData
		{
			return m_bitmapData;
		}
		
		public function get width():int
		{
			return m_width;
		}
		public function get height():int
		{
			return m_height;
		}
		public function dispose():void
		{
			m_funOnDraw = null;
			m_container.dispose();
		}
		
	}

}