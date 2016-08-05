package net.timemsg
{
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stTimerUserCmd extends stNullUserCmd
	{
		public static const GAMETIME_TIMER_USERCMD_PARA:uint = 1;
		public function stTimerUserCmd() 
		{
			super();
		}
	}
}

//struct stTimerUserCmd : public stNullUserCmd
//{
	//stTimerUserCmd()
	//{
		//byCmd = TIME_USERCMD;
	//}
//};