package com.bit101.drag
{
	import com.bit101.components.Component;
	import com.dnd.DraggingImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DragComponentBase extends Component implements DraggingImage
	{
		protected var m_display:Component;
		protected var m_disPlayX:Number = 0;
		protected var m_disPlayY:Number = 0;
		public function DragComponentBase(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_display = new Component(this);
		}
		
		public function onDrag():void
		{
			/*var retBm:Bitmap = m_con.m_dragResPool.getBitmap();
			//var retBmData:BitmapData = m_con.m_dragResPool.getBitmapData(m_display.width, m_display.height);
			var retBmData:BitmapData = new BitmapData(m_display.width, m_display.height);
			m_display.blendMode = BlendMode.LAYER;
			retBmData.draw(m_display,null,null,BlendMode.ERASE);
			retBm.bitmapData = retBmData;
			retBm.x = m_display.x;
			retBm.y = m_display.y;
			retBm.width = m_display.width;
			retBm.height = m_display.height;
			
			if (retBm.parent != this)
			{
				this.addChild(retBm);
			}*/
		}
		
		public function onDrop():void
		{
			if (m_display.parent != this)
			{
				this.addChild(m_display);
				m_display.setPos(m_disPlayX,m_disPlayY);
			}
		}
		
		override public function dispose():void
		{
			var retBm:Bitmap = m_con.m_dragResPool.getBitmap();
			if (retBm.parent == this)
			{
				this.removeChild(retBm);
			}
			if (m_display.parent != null)
			{
				m_display.parent.removeChild(m_display);
			}
			m_display.dispose();
			
			super.dispose();
		}
		
		public function get display():Component
		{
			return m_display;
		}
		
		public function getDisplay():DisplayObject
		{
			m_display.setPos(0, 0);
			return m_display;
		}
		
		/**
		 * Paints the image for accept state of dragging.(means drop allowed)
		 */
		public function switchToAcceptImage():void
		{
		}
		
		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
		public function switchToRejectImage():void
		{
		}
	}

}