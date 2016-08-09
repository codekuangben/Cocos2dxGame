package time 
{
	import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 * /*
		 * year:Number — A four-digit integer that represents the year (for example, 2000)
		 * month:Number — An integer from 0 (January) to 11 
		 * date:Number — An integer from 1 to 31.
		 * minute:Number — An integer from 0 to 59.
		 * second:Number — An integer from 0 to 59.
		 * millisecond:Number — An integer from 0 to 999.
		 * 
		 * week (0 for Sunday, 1 for Monday, and so on)
		 
	 */
	public class TimeL 
	{
		public var m_year:Number;
		public var m_month:Number;
		public var m_date:Number;
		public var m_week:int;
		public var m_hour:Number;
		public var m_minute:Number;
		public var m_second:Number;
		
		
		//1990年5月4日6点
		public function formatString_year_month_day_hour():String
		{
			return m_year.toString() + "年" + (m_month + 1).toString() + "月" + m_date.toString() + "日" + m_hour.toString() + "点";
		}
		
		//5月4日6点
		public function formatString_month_day_hour():String
		{
			return (m_month + 1).toString() + "月" + m_date.toString() + "日" + m_hour.toString() + "点";
		}
		public function formatString_ymdhms():String
		{
			var t:Number = m_hour * 3600 + m_minute * 60 + m_second;
			return m_year.toString() + "年" + (m_month + 1).toString() + "月" + m_date.toString() + "日" + UtilTools.formatTimeToString(t); 
		}
	}

}