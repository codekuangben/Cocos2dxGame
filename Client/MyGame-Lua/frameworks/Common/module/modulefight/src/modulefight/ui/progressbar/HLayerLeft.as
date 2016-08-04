package modulefight.ui.progressbar 
{
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class HLayerLeft extends HLayerBase 
	{		
		public function HLayerLeft(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);			
		}
		
		override public function setParam(imageFun:String, name:String, w:Number, h:Number):void
		{
			this.setSize(w, h);
			this[imageFun].apply(null, [name]);
			m_srcRect.width = w;
			m_srcRect.height = h;
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
			if (m_srcRect.width != showW)
			{
				m_srcRect.width = showW;
				this.scrollRect = m_srcRect;
			}
			
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
			m_virtualShade.x = realW;
		}
		
	}

}