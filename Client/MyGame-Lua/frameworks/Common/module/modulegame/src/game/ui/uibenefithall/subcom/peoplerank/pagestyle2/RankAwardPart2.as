package game.ui.uibenefithall.subcom.peoplerank.pagestyle2 
{
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import game.ui.uibenefithall.subcom.peoplerank.RankAwardBase;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankAwardPart2 extends RankAwardBase 
	{
		private var m_list:ControlListVHeight;
		private var m_first:RankAwardItemFirst;
		private var m_firstPanel:Panel;
		public function RankAwardPart2(ranks:Ranks_Style1, data:DataBenefitHall,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(ranks, data, parent, xpos, ypos);
			
			m_NO1Head.x = 40;
			m_NO1Head.y =86;
			m_nameLabel.x = 65;
			m_nameLabel.y = 176;
			m_rankBtn.x = 57;
			m_rankBtn.y = 63;
			m_firstPanel = new Panel(this);
			m_firstPanel.setPanelImageSkin("module/benefithall/peoplerank/firstpanel" + m_ranks.m_day + ".png")
			if (m_ranks.m_day==3)//因为图片大小不一所以程序调整位置
			{
				m_firstPanel.x = 20;
				m_firstPanel.y = -5;
			}
			else
			{
				m_firstPanel.x = 18;
				m_firstPanel.y = 5;
			}
			if (m_ranks.m_day == 7)//7天增加充值按钮
			{
				var btn:PushButton = new PushButton(this, 109, 50, rechargeClick);
				btn.setSkinButton1Image("module/benefithall/rebate/btnrecharge.png");
			}
			if (m_ranks.m_day == 6)//军团不要头像
			{
				m_NO1Head.visible = false;
				var juntuanlabel:Label = new Label(this, 75, 101, "军 团", UtilColor.WHITE_Yellow);
				juntuanlabel.align = CENTER;
				var tiplabel:Label = new Label(this, 75, 157, "(军团所有成员均可获得奖励)", UtilColor.WHITE_Yellow, 10);
				tiplabel.align = CENTER;
				m_nameLabel.setFontSize(14);
				m_nameLabel.y = 127;
				m_nameLabel.x = 75;
			}
			m_list = new ControlListVHeight(this, 265, 0);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = RankAwardItemV;
			
			var dataParam:Object = new Object();
			dataParam["data"] = m_dataBenefitHall;
			dataParam["ranks"] = m_ranks;
			
			param.m_dataParam = dataParam;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 0;
			param.m_intervalV = 78;
			param.m_width = 400;
			param.m_heightList = 300;
			
			var rankRwardsList:Array = m_ranks.m_rankRwards.slice(1, m_ranks.m_rankRwards.length);
			m_list.setParam(param);		
			m_list.setDatas(rankRwardsList);
			m_first = new RankAwardItemFirst(dataParam, this);
			m_first.setData(m_ranks.m_rankRwards[0]);
			
			
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
			m_first.update();
			
		}
		private function rechargeClick(e:MouseEvent):void
		{
			m_dataBenefitHall.m_gkContext.m_context.m_platformMgr.openRechargeWeb();
		}
	}

}