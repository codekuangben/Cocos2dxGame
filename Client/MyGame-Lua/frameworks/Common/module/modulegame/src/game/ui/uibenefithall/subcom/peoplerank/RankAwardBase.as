package game.ui.uibenefithall.subcom.peoplerank 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import game.ui.uichargerank.UIChargeRank;
	import modulecommon.net.msg.copyUserCmd.reqTeamBossRankUserCmd;
	import modulecommon.net.msg.rankcmd.stRankCmd;
	import modulecommon.net.msg.rankcmd.stReqRankListUserCmd;
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerSortCmd;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import com.util.UtilColor;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankAwardBase extends Component 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks:Ranks_Style1;
		protected var m_rankBtn:ButtonText;
		protected var m_NO1Head:Panel;
		protected var m_nameLabel:Label;
		public function RankAwardBase(ranks:Ranks_Style1, data:DataBenefitHall,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
			m_ranks = ranks;
			m_NO1Head = new Panel(this);
			m_nameLabel = new Label(this);
			m_nameLabel.align = CENTER;
			m_nameLabel.setFontColor(UtilColor.WHITE_Yellow);
			m_nameLabel.setBold(true);
			m_nameLabel.mouseEnabled = true;
			m_rankBtn = new ButtonText(this, 0, 0, "排行榜", onRankBtnClick);
			m_rankBtn.labelComponent.setFontColor(UtilColor.WHITE_Yellow);
			m_rankBtn.labelComponent.setBold(true);
			m_rankBtn.labelComponent.underline = true;
		}
		public function updateOnServerData():void
		{
			var data:stRetRankRewardRankInfoCmd = m_dataBenefitHall.getRankByDay(m_ranks.m_day);
			var name:String = m_dataBenefitHall.m_gkContext.m_context.m_playerResMgr.uiName(data.m_NO1User.job, data.m_NO1User.sex);
			if (name == null)
			{
				return;
			}
			var path:String = "module/benefithall/peoplerank/" + name + ".png";
			
			if (m_NO1Head.skin == null || m_NO1Head.skin.imageName != path)
			{
				m_NO1Head.setPanelImageSkin(path);
			}
			
			m_nameLabel.text = data.m_NO1User.m_name;
		}	
		private function onRankBtnClick(e:MouseEvent):void
		{
			if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Arena)
			{
				m_dataBenefitHall.m_gkContext.m_arenaMgr.req30RankList();
				m_dataBenefitHall.m_gkContext.m_UIMgr.loadForm(UIFormID.UIArenaBetialRank);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Guoguan)
			{
				var sendstReqTrialTowerSortCmd:stReqTrialTowerSortCmd = new stReqTrialTowerSortCmd();
				m_dataBenefitHall.m_gkContext.sendMsg(sendstReqTrialTowerSortCmd);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_TeamGuoguan)
			{
				var sendreqTeamBossRankUserCmd:reqTeamBossRankUserCmd = new reqTeamBossRankUserCmd();
				m_dataBenefitHall.m_gkContext.sendMsg(sendreqTeamBossRankUserCmd);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Level)
			{
				m_dataBenefitHall.m_gkContext.m_rankSys.openRankAndToggleToPage(0);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Zhanli)
			{
				m_dataBenefitHall.m_gkContext.m_rankSys.openRankAndToggleToPage(1);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_JunTuan)
			{
				m_dataBenefitHall.m_gkContext.m_rankSys.openRankAndToggleToPage(3);
			}
			else if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Recharge)
			{
				var send:stReqRankListUserCmd = new stReqRankListUserCmd();
				send.type = stRankCmd.S7DAY_RECHARGE_RANK;
				m_dataBenefitHall.m_gkContext.sendMsg(send);
			}
		}
	}

}