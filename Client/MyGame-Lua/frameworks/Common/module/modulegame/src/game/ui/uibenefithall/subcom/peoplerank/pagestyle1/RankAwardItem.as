package game.ui.uibenefithall.subcom.peoplerank.pagestyle1 
{
	import com.bit101.components.controlList.CtrolHComponent;
	import com.bit101.components.Label;
	import flash.geom.Point;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.scene.benefithall.peoplerank.RankReward;
	import modulecommon.scene.benefithall.peoplerank.Ranks_Style1;
	import com.bit101.components.Panel;
	import com.util.UtilColor;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	/**
	 * ...
	 * @author 
	 */
	public class RankAwardItem extends CtrolHComponent 
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks_Style1:Ranks_Style1;
		protected var m_rankReward:RankReward;
		
		protected var m_boxPanel:Panel;
		
		protected var m_myRankLabel:Label;
		
		public function RankAwardItem(param:Object=null) 
		{
			super(param);
			m_dataBenefitHall = param["data"];
			m_ranks_Style1 = param["ranks"];
			
			m_boxPanel = new Panel(this);
			m_boxPanel.y = 75;
		}
		
		override public function setData(_data:Object):void
		{
			super.setData(_data);
			m_rankReward = _data as RankReward;
			m_boxPanel.setPanelImageSkin("module/benefithall/peoplerank/boxclose.png");
			
			var str:String;
			if (m_rankReward.m_fromrank == 1)
			{
				this.width = 204;
				m_boxPanel.x = 113;
			}
			else
			{
				this.width = 110;
				m_boxPanel.x = 24;
				
				str = "第" + m_rankReward.m_fromrank + "-" + m_rankReward.m_torank + "名";
				var label:Label = new Label(this, 0, 13, str, UtilColor.WHITE_Yellow, 14);
				label.x = this.width / 2;
				label.align = CENTER;
				label.setBold(true);				
				label.text = str;
			}
			//this.height = 174;
			//this.drawRectDebug();
		}
		override public function onOut():void
		{
			super.onOut();
			m_boxPanel.filtersAttr(false);
			m_dataBenefitHall.m_gkContext.m_uiTip.hideTip();
		}
		
		override public function onOver():void
		{
			super.onOver();
			m_boxPanel.filtersAttr(true);
			
			if (m_rankReward.m_tip)
			{
				var pt:Point = m_boxPanel.localToScreen();			
				m_dataBenefitHall.m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, m_rankReward.m_tip, 266, true);
			}
		}
		override public function update():void 
		{
			super.update();
			
			var data:stRetRankRewardRankInfoCmd = m_dataBenefitHall.getRankByDay(m_ranks_Style1.m_day);
			if (data == null)
			{
				return;
			}
			
			if (data.selfrank >= m_rankReward.m_fromrank && data.selfrank <= m_rankReward.m_torank)
			{
				showMyRank();
			}
			else
			{
				hideMyRank();
			}
		}
		private function showMyRank():void
		{
			if (m_myRankLabel == null)
			{
				m_myRankLabel = new Label(this, 26, 138, "我的排名", UtilColor.WHITE_Yellow, 14);
				m_myRankLabel.underline = true;
				m_myRankLabel.setBold(true);
			}
			
			if (m_rankReward.m_fromrank == 1)
			{
				m_myRankLabel.x = 114;
			}
			else
			{
				m_myRankLabel.x = 26;
			}
			m_myRankLabel.mouseEnabled = true;
			m_myRankLabel.visible=true;
		}
		private function hideMyRank():void
		{
			if (m_myRankLabel)
			{
				m_myRankLabel.visible = false;
			}
		}
	}

}