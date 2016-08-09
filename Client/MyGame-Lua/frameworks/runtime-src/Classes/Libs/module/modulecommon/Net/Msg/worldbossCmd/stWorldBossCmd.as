package modulecommon.net.msg.worldbossCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stWorldBossCmd extends stNullUserCmd
	{
		public static const PARA_NOTIFY_ACT_STATE_WBCMD:uint = 1;
		public static const PARA_NOTIFY_ACT_WAITTIME_WBCMD:uint = 2;
		public static const PARA_REQ_ENTER_WORLDBOSS_WBCMD:uint = 3;
		public static const PARA_REQ_LEAVE_WORLDBOSS_WBCMD:uint = 4;
		public static const PARA_NOTIFY_BOSS_INFO_WBCMD:uint = 5;
		public static const PARA_NOTIFY_RANKLIST_INFO_WBCMD:uint = 6;
		public static const PARA_NOTIFY_RELIVE_TIME_WBCMD:uint = 7;
		public static const PARA_REQ_RELIVE_RIGHTNOW_WBCMD:uint = 8;
		public static const PARA_REQ_FIGHT_RIGHTNOW_WBCMD:uint = 9;
		public static const PARA_REQ_INSPIRE_WBCMD:uint = 10;
		public static const PARA_INSPIRE_LEFTTIMES_WBCMD:uint = 11;
		public static const PARA_REQ_ENCOURAGE_WBCMD:uint = 12;
		public static const PARA_ENCOURAGE_LEFTTIMES_WBCMD:uint = 13;
		public static const PARA_FIGHTRESULT_INFO_WBCMD:uint = 14;
		public static const PARA_JOIN_WORLD_BOSS_TIMES_WBCMD:uint = 15;
		public static const PARA_NOTIFY_BOSS_HPINFO_WBCMD:uint = 16;
		public static const PARA_BOSS_POSITION_INFO_WBCMD:uint = 17;
		
		public function stWorldBossCmd() 
		{
			super();
			byCmd = WORLDBOSS_USERCMD;
		}
		
	}

}
/*
	///世界boss相关指令
	struct stWorldBossCmd : public stNullUserCmd
	{
		stWorldBossCmd()
		{
			byCmd = WORLDBOSS_USERCMD;
		}
	};
*/