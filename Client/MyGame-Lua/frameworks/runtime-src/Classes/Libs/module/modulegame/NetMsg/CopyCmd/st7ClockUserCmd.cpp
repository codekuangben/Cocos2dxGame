package game.netmsg.copycmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class st7ClockUserCmd extends stCopyUserCmd
	{
		public function st7ClockUserCmd()
		{
			byParam = st7_CLOCK_USERCMD;
		}
	}
}


//const BYTE st7_CLOCK_USERCMD = 21;
//struct  st7ClockUserCmd: public stCopyUserCmd
//{
//	st7ClockUserCmd()
//	{
//		byParam = st7_CLOCK_USERCMD;
//	}
//};