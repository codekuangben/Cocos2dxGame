package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class PanelCut extends Component 
	{
		private var m_cutRect:Rectangle;
		public function PanelCut(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_cutRect = new Rectangle();
		}
		
		public function setCutRect(w:Number, h:Number):void
		{
			m_cutRect.width = w;
			m_cutRect.height = h;
			this.scrollRect = m_cutRect;
		}
		public function set cutRectW(w:Number):void
		{
			m_cutRect.width = w;
			this.scrollRect = m_cutRect;
		}
		
		public function get cutRectW():Number
		{			
			return this.scrollRect.width;
		}
		
	}

}