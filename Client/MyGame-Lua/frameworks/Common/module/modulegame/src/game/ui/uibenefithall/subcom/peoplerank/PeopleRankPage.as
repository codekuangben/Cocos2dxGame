package game.ui.uibenefithall.subcom.peoplerank 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.uiinterface.componentinterface.IPeopleRankPage;
	
	/**
	 * ...
	 * @author 
	 */
	public class PeopleRankPage extends PageBase implements IPeopleRankPage
	{
		private var m_rankPanel:RankPanel;
		private var m_tabPanel:TabPanel;
		public function PeopleRankPage(data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(data, parent, xpos, ypos);		
			//this.setPanelImageSkin("module/benefithall/peoplerank/bg1.png");
			
			m_rankPanel = new RankPanel(data, this);
			m_tabPanel = new TabPanel(m_rankPanel, data, this, 3, 169);
			
			m_dataBenefitHall.m_gkContext.m_peopleRankMgr.m_page = this;
		}
		
		public function process_stRetRankRewardRankInfoCmd(msg:ByteArray):void
		{
			var rev:stRetRankRewardRankInfoCmd = new stRetRankRewardRankInfoCmd();
			rev.deserialize(msg);
			m_dataBenefitHall.process_stRetRankRewardRankInfoCmd(rev);
			m_rankPanel.updateOnServerData(rev.day);
			
		}
		
		override public function dispose():void 
		{
			m_dataBenefitHall.m_gkContext.m_peopleRankMgr.m_page = null;
			super.dispose();
		}
		
		public function updateOnServerData(day:int):void
		{
			m_rankPanel.updateOnServerData(day);
		}
		
		public function onNextDay():void
		{
			var curDay:int = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			if (curDay>=1 && curDay <= 8)
			{
				m_tabPanel.onNextDay();
				m_rankPanel.onNextDay();
			}
			
		}
		public function onLingqu(day:int):void
		{
			m_rankPanel.onLingqu(day);
		}
	}

}