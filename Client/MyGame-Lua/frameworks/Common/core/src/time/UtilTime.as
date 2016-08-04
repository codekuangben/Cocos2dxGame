package time 
{
	/**
	 * ...
	 * @author ...
	 */
	public class UtilTime 
	{
		public static const TIME_ZONE_MillionSecond:Number = 8 * 60 * 60 * 1000;//北京时区(单位：毫秒）
		public static const TIME_ZONE_Second:Number = 8 * 60 * 60;//北京时区(单位：秒）
		
		
		public static const TIME_ZONE:Number = 8 * 60 * 60 * 1000;//北京时区(单位：毫秒）
		public static const DAY_SECOND:Number = 24 * 60 * 60;	//1天的秒数
		public static const DAY_MillionSecond:Number = DAY_SECOND*1000;	//1天的毫秒数
		public static const HOUR_SECOND:Number = 60 * 60;	//1小时的秒数
		/*
		 * 判断date对象所表示的时间是否大于等于(h,m)所表示的时间(仅考虑一天内的时间，而没有考虑日期)
		 * h:小时数
		 * m:分钟数
		 */
		public static function s_isGreaterOrEqualInDay(date:TimeL, h:int, m:int):Boolean
		{
			var _h:int = date.m_hour;
			if (_h < h)
			{
				return false;
			}
			
			if (_h > h)
			{
				return true;
			}
			return date.m_minute >= m;			
		}
		
		
		
		/*
		 * 计算calendarTime（日历时间，单位：秒）是第几天
		 * 规则: calendarTime		第几天
		 * [0 - hour)	 		 	  0
		 * [hour - 1天+hour)	 	  1
		 * [1天hour - 2天+hour)		  3
		 * [2天hour - 3天+hour)		  4
		 * [3天hour - 4天+hour)	  	  5
		 */
		/*public static function s_computeDay(calendarTime:Number, hour:Number):int
		{
			var nDay:Number = Math.floor(calendarTime / DAY_SECOND);			
			var a:Number = nDay * DAY_SECOND;
			if (calendarTime - a >= hour * HOUR_SECOND)
			{
				nDay += 1;
			}
			return Math.floor(nDay);			
		}*/
		
		/*
		 * 计算a与b之间的天数差
		 * 1. 保证 b>=a
		 * 2. a与b是日历时间（单位：秒）
		 * 3. 时间跨7点的时候，进入下一天
		 * 如果a与b是同一天，则返回0；
		 * 如果b是a的下一天中的时间，则返回1.依次类推
		 * 
		 *
		 */
		public static function s_computeDayDifference_7(a:Number, b:Number):int
		{
			var aDay:Number = s_curDay_7(a);
			var bDay:int = s_curDay_7(b);
			return (bDay - aDay) / DAY_SECOND;
		}
		//跨零点 同上
		public static function s_computeDayDifference_0(a:Number, b:Number):int
		{
			var aDay:Number = s_getDay_0(a);
			var bDay:int = s_getDay_0(b);
			return (bDay - aDay) / DAY_SECOND;
		}
		
		/*
		 * 返回当天零点
		 */ 
		public static function s_getDay_0(t:Number):Number
		{
			var temp:Number = Math.floor((t + TIME_ZONE_Second) / DAY_SECOND) * DAY_SECOND;
			return temp - TIME_ZONE_Second;		
		}
		 
		/*
		 * 返回当天的7点的日历时间
		 * 如果当前是5号18点，则返回5号7点
		 * 如果当前是5号9点，则返回5号7点
		 * 如果当前是5号3点，则返回4号7点
		 */
		public static function s_curDay_7(t:Number):Number
		{
			var ret:Number;
			var zero:Number = s_getDay_0(t);
			var n7:Number = 7 * HOUR_SECOND;
			if (t - zero >= n7)
			{
				ret = zero + n7;
			}
			else
			{
				ret = zero + n7 - DAY_SECOND;
			}
			return ret;
		}
		
		/*
		 * 返回下一天的7点的日历时间
		 * 如果当前是5号18点，则返回6号7点
		 * 如果当前是5号9点，则返回6号7点
		 * 如果当前是5号3点，则返回5号7点
		 */
		public static function s_NextDay_7(a:Number):Number
		{
			var ret:Number;
			var zero:Number = s_getDay_0(a);
			var n7:Number = 7 * HOUR_SECOND;
			if (a - zero <= n7)
			{
				ret = zero + n7;
			}
			else
			{
				ret = zero + n7 + DAY_SECOND;
			}
			return ret;
		}
		
	}

}