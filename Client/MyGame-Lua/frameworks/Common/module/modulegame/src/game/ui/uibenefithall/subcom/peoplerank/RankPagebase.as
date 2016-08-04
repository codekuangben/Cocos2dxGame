package game.ui.uibenefithall.subcom.peoplerank 
{
	import com.bit101.components.AniZoom;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelPage;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.msg.stReqRankRewardRankInfoCmd;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.scene.benefithall.peoplerank.RanksBase;
	import time.TimeL;
	import time.UtilTime;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankPagebase extends PanelPage 
	{
		protected var m_day:int;
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_ranks:RanksBase;
		private var m_dayPanel:Panel;
		private var m_daydigit:DigitComponent;
		private var m_sloganAni:AniZoom;
		private var m_timeLabel:Label;
		public function RankPagebase(day:int, data:DataBenefitHall, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			if (day == 2)//因为第二天的图片比较小，程序单独调整位置
			{
				m_sloganAni = new AniZoom(this, 193, 94);
			}
			else
			{
				m_sloganAni = new AniZoom(this, 200, 94);
			}
			m_sloganAni.setImageAni("module/benefithall/peoplerank/slogan" + day + ".png");
			m_sloganAni.begin();
			
			m_dayPanel = new Panel(this, 42, -10);
			m_dayPanel.setPanelImageSkin("module/benefithall/peoplerank/daypanel.png")
			m_daydigit = new DigitComponent(data.m_gkContext.m_context, m_dayPanel, 130, 20);
			m_daydigit.setParam("commoncontrol/digit/gambledigit", 40, 42);
			m_daydigit.digit = day;
			m_dataBenefitHall = data;
			m_day = day;
			m_ranks = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.getRanksBaseByDay(m_day);
			
			m_timeLabel = new Label(this, 20, 140);
			m_timeLabel.setFontColor(UtilColor.GREEN);
			m_timeLabel.setFontSize(14);
			m_timeLabel.setBold(true);
			
			var beginT:Number;
			var endT:Number;
			var openServerT:Number = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.openservertime;
			var next7:Number = UtilTime.s_NextDay_7(openServerT);
			if (m_day == 1)
			{
				beginT = openServerT;
				endT = next7;
			}
			else
			{
				beginT = next7 + UtilTime.DAY_SECOND * (m_day - 2);
				endT = beginT + UtilTime.DAY_SECOND;
			}
			
			var str:String;
			var beginTL:TimeL = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.calendarToTimeL(beginT);
			var endTL:TimeL = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.calendarToTimeL(endT);
			str = "冲榜时间：" + beginTL.formatString_month_day_hour() + " - " + endTL.formatString_month_day_hour();
			m_timeLabel.text = str;
			
			this.listenAddedToStageEvent();
		}
		override protected function onAddedToStage(e:Event):void 
		{
			var send:stReqRankRewardRankInfoCmd = new stReqRankRewardRankInfoCmd();
			send.day = m_day;
			m_dataBenefitHall.m_gkContext.sendMsg(send);
		}
		public function updateOnServerData():void
		{
		}
		override public function onShow():void
		{
			super.onShow();
			if (m_day == 2)//虽然不知道，这里为什么，但是加上这段代码就没问题了
			{
				m_sloganAni.setParam(0.9, 1.1, 16.0, 168, 36, true);
			}
			else
			{
				m_sloganAni.setParam(0.9, 1.1, 16.0, 198, 36, true);
			}
			m_sloganAni.begin();
		}
		
		override public function onHide():void 
		{
			m_sloganAni.stop();
			super.onHide();
		}
	}

}