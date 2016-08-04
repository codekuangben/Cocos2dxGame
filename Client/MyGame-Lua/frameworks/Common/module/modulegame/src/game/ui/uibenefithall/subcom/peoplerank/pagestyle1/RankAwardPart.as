package game.ui.uibenefithall.subcom.peoplerank.pagestyle1 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.controlList.ControlListH;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import modulecommon.net.msg.copyUserCmd.reqTeamBossRankUserCmd;
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerSortCmd;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.ui.UIFormID;

	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankAwardPart extends Component 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks:Ranks_Style1;
		private var m_list:ControlListH;
		
		private var m_rankBtn:ButtonText;
		private var m_NO1Head:Panel;
		private var m_nameLabel:Label;
		public function RankAwardPart(ranks:Ranks_Style1, data:DataBenefitHall,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
			m_ranks = ranks;
			
			m_list = new ControlListH(this, 8, 0);
			var param:ControlHAlignmentParam = new ControlHAlignmentParam();
			param.m_class = RankAwardItem;
			
			var dataParam:Object = new Object();
			dataParam["data"] = m_dataBenefitHall;
			dataParam["ranks"] = m_ranks;
			
			param.m_dataParam = dataParam;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 0;
			param.m_intervalH = 2;
			param.m_height = 174;
			param.m_widthList = 651;
			
			m_list.setParam(param);		
			m_list.setDatas(m_ranks.m_rankRwards);
			//m_list.drawRectDebug();
			
			m_NO1Head = new Panel(this, 36, 45);
			m_nameLabel = new Label(this, 65, 135);
			m_nameLabel.align = CENTER;
			m_nameLabel.setFontColor(UtilColor.WHITE_Yellow);
			//m_nameLabel.setFontSize(14);
			m_nameLabel.setBold(true);
			m_nameLabel.mouseEnabled = true;		
			
			m_rankBtn = new ButtonText(this, 156, 22, "排行榜", onRankBtnClick);
			m_rankBtn.labelComponent.underline = true;
		}
		
		public function updateOnServerData():void
		{
			var data:stRetRankRewardRankInfoCmd = m_dataBenefitHall.getRankByDay(m_ranks.m_day);
			if (data == null)
			{
				return;
			}
			
			var name:String = m_dataBenefitHall.m_gkContext.m_context.m_playerResMgr.uiName(data.m_NO1User.job, data.m_NO1User.sex);
			var path:String = "module/benefithall/peoplerank/" + name + ".png";
			
			if (m_NO1Head.skin == null || m_NO1Head.skin.imageName != path)
			{
				m_NO1Head.setPanelImageSkin(path);
			}
			
			m_nameLabel.text = data.m_NO1User.m_name;
			m_list.update();
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
			if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Level)
			{
				m_dataBenefitHall.m_gkContext.m_rankSys.openRankAndToggleToPage(0);
			}
			if (m_ranks.m_type == PeopleRankMgr.RANKTYPE_Zhanli)
			{
				m_dataBenefitHall.m_gkContext.m_rankSys.openRankAndToggleToPage(1);
			}
		}
	}

}