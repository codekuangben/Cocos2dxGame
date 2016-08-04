package game.ui.uibenefithall.subcom.peoplerank.pagestyle1 
{
	import com.bit101.components.ButtonText;
	import game.ui.uibenefithall.subcom.peoplerank.RankAwardBase;
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
	public class RankAwardPart1 extends RankAwardBase 
	{
		/*protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks:Ranks_Style1;*/
		private var m_list:ControlListH;
		
		/*private var m_rankBtn:ButtonText;
		private var m_NO1Head:Panel;
		private var m_nameLabel:Label;*/
		public function RankAwardPart1(ranks:Ranks_Style1, data:DataBenefitHall,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			m_list = new ControlListH(this, 8, 0);
			super(ranks,data,parent, xpos, ypos);
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
			m_NO1Head.x = 36;
			m_NO1Head.y = 45;
			m_nameLabel.x = 65;
			m_nameLabel.y = 135;
			m_rankBtn.x = 156;
			m_rankBtn.y = 22;
		}
		override public function updateOnServerData():void 
		{
			var data:stRetRankRewardRankInfoCmd = m_dataBenefitHall.getRankByDay(m_ranks.m_day);
			if (data == null)
			{
				return;
			}
			super.updateOnServerData();
			m_list.update();
		}
	}

}