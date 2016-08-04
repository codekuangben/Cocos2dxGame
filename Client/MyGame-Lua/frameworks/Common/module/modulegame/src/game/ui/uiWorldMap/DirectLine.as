package game.ui.uiWorldMap 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 * 可以指定方向，长度
	 */
	public class DirectLine extends Component 
	{
		protected var m_linePanel:Panel;
		public function DirectLine(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);			
			m_linePanel = new Panel(this);
		}
		
		public function setLinePanel(strName:String, xPos:Number, yPos:Number):void
		{
			m_linePanel.setPanelImageSkin(strName);
			m_linePanel.setPos(xPos, yPos);
			
		}
		
	}

}