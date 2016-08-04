package game.ui.uibenefithall.subcom.regdaily 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import time.TimeL;
	import time.TimeMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class MonthPanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_regDailyPage:RegDailyPage;
		private var m_vecDays:Vector.<ItemDay>;
		private var m_weekByFirstDay:uint;	//本月第一天是星期几
		private var m_date:TimeL;
		
		private var m_todayPanel:Panel;		//“今日”背景图片
		
		public function MonthPanel(gk:GkContext, regdailypage:RegDailyPage, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_regDailyPage = regdailypage;
			
			m_vecDays = new Vector.<ItemDay>(42);
		}
		
		public function initData():void
		{
			m_date = m_gkContext.m_context.m_timeMgr.getServerTimeL();
			
			var month:Point = TimeMgr.s_priMonth(m_date.m_year, m_date.m_month);
			var premonthDays:uint = TimeMgr.s_numOfdaysInMonth(month.x, month.y);
			var curmonthDays:uint = TimeMgr.s_numOfdaysInMonth(m_date.m_year, m_date.m_month);
			m_weekByFirstDay = TimeMgr.s_weekByDate(m_date.m_year, m_date.m_month, 1);
			
			var i:int;
			var day:uint = m_weekByFirstDay;
			var count:uint = curmonthDays;
			var itemday:ItemDay;
			var oneday:uint;
			var bcurmonth:Boolean;
			var bworkday:Boolean;
			var btoday:Boolean;
			for (i = 0; i < m_vecDays.length; i++)
			{
				itemday = new ItemDay(m_regDailyPage, this);
				if (day > 0)
				{
					oneday = premonthDays - day + 1;
					bcurmonth = false;
					day--;
				}
				else if (count > 0)
				{
					oneday = i - m_weekByFirstDay + 1;
					bcurmonth = true;
					count--;
					
					if (m_date.m_date == oneday)
					{
						btoday = true;
					}
				}
				else
				{
					oneday = i - curmonthDays - m_weekByFirstDay + 1;
					bcurmonth = false;
				}
				
				if (Math.floor(i % 7) > 0 && Math.floor(i % 7) < 6)
				{
					bworkday = true;
				}
				else
				{
					bworkday = false;
				}
				
				itemday.setNum(oneday, bcurmonth, bworkday);
				
				if (btoday && (null == m_todayPanel))
				{
					m_todayPanel = new Panel(itemday, 0, 0);
					m_todayPanel.setPanelImageSkinBySWF(m_regDailyPage.resource, "regdaily.dateover");
					btoday = false;
				}
				
				if (bcurmonth && m_gkContext.m_dailyActMgr.isReg(oneday - 1))
				{
					itemday.setSelect();
				}
				
				m_vecDays[i] = itemday;
			}
			
			updatePos();
		}
		
		private function updatePos():void
		{
			var i:int;
			var w:int = m_vecDays[0].width + 3;
			var h:int = m_vecDays[0].height+ 2;
			for (i = 0; i < m_vecDays.length; i++)
			{
				m_vecDays[i].setPos(Math.floor(i % 7) * w, Math.floor(i / 7) * h);
			}
		}
		
		//更新本月签到信息
		public function updateRegInfo(bnewmonth:Boolean = false):void
		{
			m_gkContext.addLog("MonthPanel.as::updateRegInfo");
			m_date = m_gkContext.m_context.m_timeMgr.getServerTimeL();
			
			var month:Point = TimeMgr.s_priMonth(m_date.m_year, m_date.m_month);
			var premonthDays:uint = TimeMgr.s_numOfdaysInMonth(month.x, month.y);
			var curmonthDays:uint = TimeMgr.s_numOfdaysInMonth(m_date.m_year, m_date.m_month);
			m_weekByFirstDay = TimeMgr.s_weekByDate(m_date.m_year, m_date.m_month, 1);
			
			var day:uint = m_weekByFirstDay;
			var count:uint = curmonthDays;
			var itemday:ItemDay;
			var oneday:uint;
			var bcurmonth:Boolean;
			var btoday:Boolean = false;
			var i:int;
			
			for (i = 0; i < m_vecDays.length; i++)
			{
				itemday = m_vecDays[i];
				if (day > 0)
				{
					oneday = premonthDays - day + 1;
					bcurmonth = false;
					day--;
				}
				else if (count > 0)
				{
					oneday = i - m_weekByFirstDay + 1;
					bcurmonth = true;
					
					if (m_date.m_date == oneday)
					{
						btoday = true;
					}
					
					count--;
				}
				else
				{
					oneday = i - curmonthDays - m_weekByFirstDay + 1;
					bcurmonth = false;
				}
				
				if (btoday && m_todayPanel)
				{
					itemday.addChild(m_todayPanel);
					btoday = false;
				}
				
				if (bcurmonth)
				{
					if (m_gkContext.m_dailyActMgr.isReg(oneday - 1))
					{
						itemday.setSelect();
					}
					else
					{
						itemday.clearSelect();
					}
				}
				
				//新月份，更新日期显示
				if (bnewmonth)
				{
					var bworkday:Boolean;
					if (Math.floor(i % 7) > 0 && Math.floor(i % 7) < 6)
					{
						bworkday = true;
					}
					else
					{
						bworkday = false;
					}
					itemday.setNum(oneday, bcurmonth, bworkday);
				}
			}
		}
		
		public function onRegistration():void
		{
			var i:int;
			m_date = m_gkContext.m_context.m_timeMgr.getServerTimeL();
			i = m_date.m_date + m_weekByFirstDay - 1;
			if (m_vecDays[i])
			{
				m_vecDays[i].setSelect();
			}
		}
		
	}

}