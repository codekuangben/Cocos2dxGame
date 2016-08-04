package modulefight.ui.progressbar 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 
	 */
	public class HLayerRight extends HLayerBase 
	{
		private var m_panel:Panel;		
		
		public function HLayerRight(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{			
			super(parent, xpos, ypos);			
			m_panel = new Panel(this);
			m_panel.autoSizeByImage = false;
			this.swapChildren(m_panel, m_virtualShade);
		}
		
		override public function setParam(imageFun:String, name:String, w:Number, h:Number):void
		{
			this.setSize(w, h);
			m_srcRect.height = h;
			m_panel.setSize(w, h);
			m_panel[imageFun].apply(null, [name]);
		}
		
		/*
		 * 
		 * realValue - 实际长度
		 * showValue-显示长度 = realValue+virtualValue
		 */ 
		override public function setValues(showValue:Number, realValue:Number):void
		{
			var showW:Number = showValue * this.width;
			var realW:Number = realValue * this.width;
			
			m_srcRect.width = showW;
			m_srcRect.x = this.width - showW;
			m_panel.scrollRect = m_srcRect;
			m_panel.x = m_srcRect.x;
			
			var virtualW:Number;
			if (showValue >= realValue)
			{
				virtualW = showW - realW;
			}
			else
			{
				virtualW = 0;
			}
			
			m_virtualShade.graphics.clear();
			m_virtualShade.graphics.beginFill(0xffffff, 0.4);
			m_virtualShade.graphics.drawRect(0, 0, virtualW, this.height);
			m_virtualShade.graphics.endFill();
			m_virtualShade.x = m_srcRect.x;
		}
	}

}