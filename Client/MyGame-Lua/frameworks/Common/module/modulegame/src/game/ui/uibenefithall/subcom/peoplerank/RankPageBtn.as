package game.ui.uibenefithall.subcom.peoplerank 
{
	import com.bit101.components.ButtonTab;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankPageBtn extends ButtonTab 
	{
		public static const STATE_UnOpen:int = 0;	//未开启
		public static const STATE_Going:int = 1;	//进行中
		public static const STATE_Over:int = 2;	//结束
		private var m_state:int = STATE_UnOpen;
		private var m_markPanel:Panel;
		public function RankPageBtn(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null) 
		{
			super(parent, xpos, ypos, defaultHandler);
			m_markPanel = new Panel(this, 151, -4);
			m_markPanel.mouseEnabled = false;
			m_markPanel.mouseChildren = false;
		}
		
		public function setMark(state:int):void
		{
			if (m_state == state)
			{
				return;
			}
			
			m_state = state;
			if (m_state == STATE_Going)
			{
				m_markPanel.setPanelImageSkin("module/benefithall/peoplerank/going.png");
			}
			else if (m_state == STATE_Over)
			{
				m_markPanel.setPanelImageSkin("module/benefithall/peoplerank/over.png");				
			}
		}
	
	}

}