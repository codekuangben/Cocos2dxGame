package time 
{
	/**
	 * ...
	 * @author ...
	 */
	import common.Context;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class TimeMgr
	{		
		private var m_context:Context;
		private var m_bInited:Boolean = false;	//true-已经处理过stGameTimeTimerUserCmd
		
		protected var m_initCalendarTime:Number;	//millonsecond
		protected var m_initVMTime:Number;			//millonsecond
		protected var m_openservertime:Number;		//开服的时间(秒)
		protected var m_dayOfOpenServer_7:int;		//开服第几天（跨7点算是过一天）。1. 开服第1天，2. 开服第2天
		
		protected var m_date:Date;
		protected var m_todayTimeL:TimeL;
		
		protected var m_todayZeorTime:Number;	//今日零点的日历时间。millonsecond
		
		protected var m_localTimeStart:Number;
		protected var m_relativeTimeStart:int;
		
		public function TimeMgr(gk:Context) 
		{
			m_context = gk;
			m_date = new Date();
			m_localTimeStart = m_date.time;
			m_relativeTimeStart = getTimer();
			m_todayTimeL = new TimeL();			
		}
		
		/*
		 * calendarTime 日历时间，单位秒
		 * 返回系统时间
		 */ 
		public function calendarTimeToPlatformTime(calendarTime:Number):Number
		{
			return m_initVMTime + calendarTime * 1000 - m_initCalendarTime;
		}
		
		private function updateTodayDate(t:Number):void
		{
			m_date.setTime(t + UtilTime.TIME_ZONE_MillionSecond);
			m_todayTimeL.m_year = m_date.fullYearUTC;
			m_todayTimeL.m_month = m_date.monthUTC;
			m_todayTimeL.m_date = m_date.dateUTC;
			m_todayTimeL.m_week = m_date.dayUTC;			
		}
		//输入参数的单位是毫秒
		public function setTime(t:Number, openservertime:Number):void
		{
			if (m_bInited)
			{
				return;
			}
			m_bInited = true;
			
			m_initCalendarTime = t*1000;
			m_initVMTime = m_context.m_processManager.platformTime;
			m_openservertime = openservertime;
			m_dayOfOpenServer_7 = UtilTime.s_computeDayDifference_7(m_openservertime, t) + 1;
			
			m_todayZeorTime = UtilTime.s_getDay_0(m_initCalendarTime);
			updateTodayDate(m_initCalendarTime);
		}
		public function getServerTimeL():TimeL
		{
			m_date.setTime(m_context.m_processManager.platformTime - m_initVMTime + m_initCalendarTime+UtilTime.TIME_ZONE_MillionSecond);

			m_todayTimeL.m_hour = m_date.hoursUTC;
			m_todayTimeL.m_minute = m_date.minutesUTC;
			m_todayTimeL.m_second = m_date.secondsUTC;
			return m_todayTimeL;			
		}
		
		/*时间转化：将日历时间转化为（TimeL结构)
		 * calendarTime:日历时间（单位:秒）
		 */ 
		public function calendarToTimeL(calendarTime:Number):TimeL
		{
			m_date.setTime(calendarTime * 1000 + UtilTime.TIME_ZONE_MillionSecond);	
			var ret:TimeL			
			ret = new TimeL();
			
			ret.m_year = m_date.fullYearUTC;
			ret.m_month = m_date.monthUTC;
			ret.m_date = m_date.dateUTC;
			ret.m_hour = m_date.hoursUTC;
			ret.m_minute = m_date.minutesUTC;
			ret.m_second = m_date.secondsUTC;
			return ret;
		}
		//返回上一个月.返回值:x-year;y-month
		public static function s_priMonth(year:Number, month:Number):Point
		{
			var ret:Point = new Point();
			if (month == 0)
			{
				ret.x = year - 1;
				ret.y = 11;
			}
			else
			{
				ret.x = year;
				ret.y = month-1;
			}
			return ret;
		}
		//返回下一个月.返回值:x-year;y-month
		public static function s_nextMonth(year:Number, month:Number):Point
		{
			var ret:Point = new Point();
			if (month == 11)
			{
				ret.x = year + 1;
				ret.y = 0;
			}
			else
			{
				ret.x = year;
				ret.y = month+1;
			}
			return ret;
		}
		
		/*
		 * year:Number — A four-digit integer that represents the year (for example, 2000)
		 * month:Number — An integer from 0 (January) to 11 
		 * date:Number — An integer from 1 to 31.
		 * minute:Number — An integer from 0 to 59.
		 * second:Number — An integer from 0 to 59.
		 * millisecond:Number — An integer from 0 to 999.
		 * 
		 * week (0 for Sunday, 1 for Monday, and so on)
		 */ 
		public static function s_numOfdaysInMonth(year:Number, month:Number):Number
		{
			var nextMonth:Point = s_nextMonth(year, month);
			
			var n:Number = (Date.UTC(nextMonth.x, nextMonth.y, 1) - Date.UTC(year, month, 1)) / 86400000;// (1000 * 60 * 60 * 24);
			return n;
		}
		
		//根据年月日，返回星期几
		public static function s_weekByDate(year:Number, month:Number, date:Number):Number
		{
			var da:Date = new Date(year, month, date);
			return da.getDay();
		}
		
		
		public function get dataString():String
		{
			var strDate:String;
			getServerTimeL();
	
			strDate = m_todayTimeL.m_year + ":" + (m_todayTimeL.m_month + 1).toString() + ":" + m_todayTimeL.m_date + "_" + m_todayTimeL.m_hour + ":" + m_todayTimeL.m_minute + ":" + m_todayTimeL.m_second;
			return strDate;
		}
		public function get dataStringEx():String
		{
			var strDate:String;
			getServerTimeL();		
			strDate = m_todayTimeL.m_year + "a" + (m_todayTimeL.m_month + 1).toString() + "a" + m_todayTimeL.m_date + "_" + m_todayTimeL.m_hour + "a" + m_todayTimeL.m_minute + "a" + m_todayTimeL.m_second;
			return strDate;
		}
		public function get dataStringWithoutYear():String
		{
			var strDate:String;
			getServerTimeL();
			strDate = (m_todayTimeL.m_month + 1).toString() + "a" + m_todayTimeL.m_date + "_" + m_todayTimeL.m_hour + "a" + m_todayTimeL.m_minute + "a" + m_todayTimeL.m_second;
			return strDate;
		}
		
		public function get timeString():String
		{
			var strDate:String;
			getServerTimeL();
			strDate = m_todayTimeL.m_hour + ":" + m_todayTimeL.m_minute + ":" + m_todayTimeL.m_second;
			return strDate;
		}
		//返回当前日历时间，单位：毫秒
		public function getCalendarTimeMillionSecond():Number
		{
			return m_context.m_processManager.platformTime - m_initVMTime + m_initCalendarTime;
		}
		//返回当前日历时间，单位：秒
		public function getCalendarTimeSecond():Number
		{
			return (m_context.m_processManager.platformTime - m_initVMTime + m_initCalendarTime)/1000;
		}
		
		// 获取小时分秒字符串
		public function get hmsString():String
		{
			var strDate:String;
			getServerTimeL();
			strDate = m_todayTimeL.m_hour + ":" + m_todayTimeL.m_minute + ":" + m_todayTimeL.m_second;
			return strDate;
		}
		
		public function process7ClockUserCmd():void
		{
			m_dayOfOpenServer_7++;
		}
		
		//零点刷新
		public function process0ClockUserCmd():void
		{
			m_todayZeorTime += UtilTime.DAY_MillionSecond;
			updateTodayDate(m_initCalendarTime);
		}
		
		public function get dayOfOpenServer_7():int
		{
			return m_dayOfOpenServer_7;
		}
		public function get initCalendarTime():Number
		{
			return m_initCalendarTime;
		}
		public function get openservertime():Number
		{
			return m_openservertime;
			//return m_initCalendarTime / 1000;
		}
		
		public function get isInit():Boolean
		{
			return m_bInited;
		}
		
		public function get localTimeStart():Number
		{
			return m_localTimeStart;
		}
		public function get relativeTimeStart():int
		{
			return m_relativeTimeStart;
		}
		
		public function get todayTimeL():TimeL
		{
			return m_todayTimeL;
		}
	}

}