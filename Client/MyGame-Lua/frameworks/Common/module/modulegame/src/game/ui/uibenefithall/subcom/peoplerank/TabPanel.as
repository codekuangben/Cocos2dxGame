package game.ui.uibenefithall.subcom.peoplerank 
{
	import com.bit101.components.Component;
	import com.hurlant.util.der.Integer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.DataBenefitHall;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class TabPanel extends Component
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		private var m_rankPanel:RankPanel;
		
		private var m_dicTab:Dictionary;
		private var m_tabSelected:int = -1;	//取值[1,7];
		public function TabPanel(rankPanel:RankPanel, data:DataBenefitHall, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_dataBenefitHall = data;
			m_rankPanel = rankPanel;
			
			
			m_dicTab = new Dictionary();
			
			var curDay:int = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			var dayArray:Array = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.get3DaysInCurDay(curDay);
			var day:int;
			for each(day in dayArray)
			{
				m_dicTab[day] = createBtnForDay(day);
			}
			adjustBtnpos();
			
			var showDay:int;
			if (curDay >= 7)
			{
				showDay = 7;
			}
			else
			{
				showDay = curDay;
			}
			setSelected(showDay);
		}	
		
		//跨过凌晨7点
		public function onNextDay():void
		{
			var curDay:int = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			var dayArray:Array = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.get3DaysInCurDay(curDay);
			var day:int;
			var btn:RankPageBtn;
			if (curDay >= 2)
			{
				var lastDay:int=curDay-1;
				var lastArray:Array = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.get3DaysInCurDay(lastDay);
				for each(day in lastArray)
				{
					if (dayArray.indexOf(day) == -1)
					{
						btn = m_dicTab[day];
						removeBtn(btn);
						delete m_dicTab[day];
						m_rankPanel.removePage(day);
					}
				}
			}
			
			
			for each(day in dayArray)
			{
				if (m_dicTab[day] == undefined)
				{
					m_dicTab[day] = createBtnForDay(day);
				}
			}
			adjustBtnpos();
			
			var showDay:int;
			if (curDay >= 7)
			{
				showDay = 7;
			}
			else
			{
				showDay = curDay;
			}
			setSelected(showDay);			
		}
			
		private function createBtnForDay(day:int):RankPageBtn
		{
			var titleName:String;
			var ret:RankPageBtn = new RankPageBtn(this, 0, 0);
			ret.setSize(221, 34);
			ret.tag = day;
			ret.addEventListener(MouseEvent.CLICK, onTabBtnClick);
			ret.setSkinButton2ImageAndImageCaptionForTab("commoncontrol/button/button2ImageTab3.swf", "module/benefithall/peoplerank/day" + day + ".png");
			return ret;
		}
		private function removeBtn(btn:RankPageBtn):void
		{
			if (btn.parent)
			{
				btn.parent.removeChild(btn);
				btn.dispose();
				btn.removeEventListener(MouseEvent.CLICK, onTabBtnClick);
			}
		}
		
		private function adjustBtnpos():void
		{
			var left:Number=0;
			var i:int;
			var btn:RankPageBtn;
			var day:int;
			var state:int;
			var curDay:int = m_dataBenefitHall.m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			var dayArray:Array = m_dataBenefitHall.m_gkContext.m_peopleRankMgr.get3DaysInCurDay(curDay);
			for (i = 0; i < 3; i++)
			{
				day = dayArray[i];
				btn = m_dicTab[day];
				btn.x = left;
				
				if (day < curDay)
				{
					state = RankPageBtn.STATE_Over;
				}
				else if (day == curDay)
				{
					state = RankPageBtn.STATE_Going;
				}
				else
				{
					state = RankPageBtn.STATE_UnOpen;
				}
				btn.setMark(state);
				left += 221;
			}
		}
		
		private function onTabBtnClick(e:MouseEvent):void
		{
			var btn:RankPageBtn = e.target as RankPageBtn;
			if (btn.tag == m_tabSelected)
			{
				return;
			}
			
			m_tabSelected = btn.tag;
			m_rankPanel.showPage(m_tabSelected);
		}
		
		public function setSelected(day:int):void
		{
			if (day == m_tabSelected)
			{
				return;
			}
			m_tabSelected = day;
			m_rankPanel.showPage(m_tabSelected);
			
			var btn:RankPageBtn = m_dicTab[day]as RankPageBtn;
			if (btn.selected == false)
			{
				btn.selected = true;
			}
		}
	}

}