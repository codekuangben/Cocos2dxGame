package modulecommon.time 
{
	/**
	 * ...
	 * @author ...
	 * 某一点时间: 小时:分钟:秒
	 */
	public class TimeItem 
	{
		public var hour:uint;
		public var min:uint;
		public var sec:uint;
		
		public function TimeItem() 
		{
			hour = 0;
			min = 0;
			sec = 0;
		}
		
		//return: 相对于当天零点所过去的时间，(单位：秒)
		public function get elpasedTimeToZero():uint
		{			
			return hour * 3600 + min * 60 + sec;
		}
		//解析时间(格式：[hour:minute], 例如9:30 - 9点30分)
		public function parse_hourAndMinute(strTime:String):void
		{
			var ar:Array = strTime.split(":");
			hour = parseInt(ar[0]);
			min = parseInt(ar[1]);
			sec = 0;
		}
		
	}

}