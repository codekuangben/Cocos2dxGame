package modulecommon.net.msg.eliteBarrierCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stEliteBarrierCmd extends stNullUserCmd 
	{
		public static const PARA_REQ_BARRIER_DATA_CMD:uint = 1;
		public static const PARA_RET_BARRIER_DATA_CMD:uint = 2;
		public static const PARA_RET_CUR_BARRIER_CMD:uint = 3;
		public static const PARA_REQ_ENTER_BARRIER_CMD:uint = 4;
		public static const PARA_REQ_UIINFO_CMD:uint = 5;
		public static const PARA_RET_UIINFO_CMD:uint = 6;
		public static const PARA_REQ_START_FIGHT_CMD:uint = 7;
		public static const PARA_REQ_LEAVE_BARRIER_CMD:uint = 8;
		public static const PARA_RET_SLAVEINFO_CMD:uint = 9;
		public static const PARA_TIAOZHAN_RESULT_CMD:uint = 10;
		public static const PARA_TIAOZHAN_NEXT_GUANKA_CMD:uint = 11;
		public static const PARA_LEFT_TIAOZHAN_ONLINE_CMD:uint = 12;
		public static const PARA_BUY_CHALLENGE_TIMES_CMD:uint = 13;
		public static const PARA_REFRESH_BUY_CHALLENGE_TIMES_CMD:uint = 14;
		public static const PARA_REQ_INTO_ELITE_BOSS_COPY_CMD:uint = 15;
		public static const PARA_NOTIFY_ELITE_BOSS_INFO_CMD:uint = 16;
		public static const PARA_ELITE_BOSS_ONLINE_INFO_CMD:uint = 17;
		public function stEliteBarrierCmd() 
		{
			byCmd = ELITE_BARRIER_CMD;
		}
		
	}

}

///精英关卡
	/*struct stEliteBarrierCmd : public stNullUserCmd
	{
		stEliteBarrierCmd()
		{
			byCmd = ELITE_BARRIER_CMD;13
		}
	};*/