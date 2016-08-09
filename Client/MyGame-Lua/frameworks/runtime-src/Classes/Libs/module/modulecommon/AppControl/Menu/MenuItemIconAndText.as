package modulecommon.appcontrol.menu 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.appcontrol.PanelDisposeEx;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class MenuItemIconAndText extends MenuItemBase 
	{
		public var m_mousePanel:PanelDisposeEx;
		public var m_icon:Panel;
		public var m_text:Label;
		public function MenuItemIconAndText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_icon = new Panel(this, 5, 3);
			m_icon.mouseEnabled = false;
			m_text = new Label(this, 28, 4);
			m_text.setFontColor(UtilColor.WHITE_Yellow);		
			
			
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);			
		}
		
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
			this.drawRectBG();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{			
			m_mousePanel.hide(this);			
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_mousePanel.parent != this)
			{
				this.addChildAt(m_mousePanel, 0);
			}			
		}
		
	}

}