package com.bit101.components
{
	import common.event.UIEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	//import flash.display.Sprite;
	//import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author
	 */
	public class PanelDraw extends Component
	{
		private var m_bitmap:Bitmap;
		private var m_bitmapData:BitmapData;
		private var m_container:Panel;
		
		private var m_bNotDisposeAfterDraw:Boolean;	//true - draw之后，不执行dipose操作
		private var m_isAllImageLoaded:Boolean;	
		private var m_bNotDraw:Boolean; //true - 表示不会执行drawPanel中的内容。用于调试情况
		
		public function PanelDraw(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_bitmap = new Bitmap();
			this.addChild(m_bitmap);		
			m_container = new Panel();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (m_bNotDisposeAfterDraw == false)
			{
				m_container.dispose();
			}

			if(m_bitmap)
			{
				m_bitmap.bitmapData = null;
			}
			if(m_bitmapData)
			{
				m_bitmapData.dispose();
				m_bitmapData = null;
			}
		}
		
		public function beginDraw():void
		{			
			clearContainer();			
			m_isAllImageLoaded = false;
		}
		
		public function endDraw():void
		{
		
		}
		
		public function drawPanel():void
		{
			if (m_bNotDraw)
			{
				return;
			}					
			
			m_container.addEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
			m_container.beginCheckImageLoaded();	
		}
		
		private function onAllImageLoaded(e:UIEvent):void
		{
			drawIt();
			this.m_container.removeEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
		}
		override public function checkImageLoaded():void 
		{
			if (isAllImagesLoaded())
			{
				return;
			}
			
			//_bInCheckIngForImageLoaded = true;
			this.addEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);			
		}
		private function drawIt():void
		{
			m_bitmapData = new BitmapData(this.width, height, true, 0xffffff);
			m_bitmapData.draw(m_container);
			m_bitmap.bitmapData = m_bitmapData;
			if (m_bNotDisposeAfterDraw==false)
			{
				m_container.dispose();
			}
			clearContainer();
						
			m_isAllImageLoaded = true;
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
		
		protected function clearContainer():void
		{
			var i:int = m_container.numChildren - 1;
			while (i >= 0)
			{
				m_container.removeChildAt(i);
				i--;
			}			
		}
		
		public function addDrawCom(sp:DisplayObject, needWait:Boolean = false):void
		{
			if (sp is Label)
			{
				(sp as Label).flush();
			}
			m_container.addChild(sp);		
		}	
		
		public function addContainer():void
		{
			m_bNotDraw = true;
			this.addChild(m_container);
			m_isAllImageLoaded = true;
		}
		
		public function set notDisposeAfterDraw(flag:Boolean):void
		{
			m_bNotDisposeAfterDraw = flag;
		}
		override public function isAllImagesLoaded():Boolean 
		{
			if (m_isAllImageLoaded)
			{
				return true;
			}
			return m_container.isAllImagesLoaded();			
		}
		override public function getFirstImagesNameNotLoaded():Component 
		{
			if (m_isAllImageLoaded)
			{
				return null;
			}
			return m_container.getFirstImagesNameNotLoaded();
		}
		
		public function get container():Panel
		{
			return m_container;
		}
		
		override public function findDisplay(funJudge:Function):DisplayObject
		{
			if (funJudge(this) == true)
			{
				return this;
			}
			
			return m_container.findDisplay(funJudge);			
		}
	}

}