package modulecommon.scene.benefithall.dailyactivities 
{
	import modulecommon.time.TimeItem;
	/**
	 * ...
	 * @author ...
	 * 某一时间段
	 */
	public class TimeInterval 
	{
		public var m_begin:TimeItem;	//开始时间
		public var m_end:TimeItem;		//结束时间
		
		public function TimeInterval() 
		{
			m_begin = new TimeItem();
			m_end = new TimeItem();
		}
		
		public function setBeginTime(hour:uint = 0, min:uint = 0, sec:uint = 0):void
		{
			m_begin.hour = hour;
			m_begin.min = min;
			m_begin.sec = sec;
		}
		
		public function setEndTime(hour:uint = 0, min:uint = 0, sec:uint = 0):void
		{
			m_end.hour = hour;
			m_end.min = min;
			m_end.sec = sec;
		}
		
		public function get timeStrHourMin():String
		{
			var ret:String;
			
			ret = m_begin.hour.toString() + "：";
			if (m_begin.min < 10)
			{
				ret += "0";
			}
			ret += m_begin.min.toString();
			ret += "~";
			ret += m_end.hour.toString() + "：";
			if (m_end.min < 10)
			{
				ret += "0";
			}
			ret += m_end.min.toString();
			
			return ret;
		}
		
		public function get timeStrHourMinSec():String
		{
			var ret:String;
			
			ret = m_begin.hour.toString() + "：";
			if (m_begin.min < 10)
			{
				ret += "0";
			}
			ret += m_begin.min.toString() + "：";
			if (m_begin.sec < 10)
			{
				ret += "0";
			}
			ret += m_begin.sec.toString();
			ret += "~";
			ret += m_end.hour.toString() + "：";
			if (m_end.min < 10)
			{
				ret += "0";
			}
			ret += m_end.min.toString() + "：";
			if (m_end.sec < 10)
			{
				ret += "0";
			}
			ret += m_end.sec.toString();
			
			return ret;
		}
	}

}