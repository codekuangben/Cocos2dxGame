package modulecommon.net.msg.stResRobCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stResRobCmd extends stNullUserCmd 
	{
		public static const SYN_RES_ROB_TIMES_USERCMD:uint = 1;
		public static const SYN_INTO_ROB_RES_DATA_USERCMD:uint = 2;
		public static const UPDATE_JIFEN_USERCMD:uint = 3;
		public static const REQ_PAI_HANG_BANG_USERCMD:uint = 4;
		public static const RET_GE_REN_PAI_HANG_BANG_USERCMD:uint = 5;
		public static const RET_ZHEN_YING_PAI_HANG_BANG_USERCMD:uint = 6;
		public static const UPDATE_TITLE_NINE_USERCMD:uint = 7;
		public static const NOTIFY_BEGIN_PLAY_PROGRESS_USERCMD:uint = 8;
		public static const REQ_END_PLAY_PROGRESS_USERCMD:uint = 9;
		public static const REQ_RELIVE_USERCMD:uint = 10;
		public static const RET_GE_REN_TOTAL_PAI_HANG_BANG_USERCMD:uint = 11;
		public static const REQ_FINISH_FIGHT_USERCMD:uint = 12;
		public static const UPDATE_RES_ROB_BUFFER_USERCMD:uint = 13;
		public static const UPDATE_RES_ROB_WIN_TIME_DOWN_COUNT_USERCMD:uint = 14; 
		public function stResRobCmd() 
		{
			super();
			byCmd = RESROB_USERCMD; //23
		}
		
	}

}

/*struct stResRobCmd : public stNullUserCmd
	{
		stResRobCmd()
		{
			byCmd = RESROB_USERCMD; //23
		}
	};*/