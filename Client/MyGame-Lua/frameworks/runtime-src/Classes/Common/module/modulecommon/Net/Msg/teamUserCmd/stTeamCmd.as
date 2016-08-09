package modulecommon.net.msg.teamUserCmd
{
	import common.net.msg.basemsg.stNullUserCmd;

	public class stTeamCmd extends stNullUserCmd
	{
		public static const NOTIFY_TEAM_MEMBER_LIST_USERCMD:uint = 1;
		public static const REQ_LEADER_TAKE_OFF_TEAM_MEMBER_USERCMD:uint = 2;
		public static const TAKE_OFF_TEAM_MEMBER_USERCMD:uint = 3;
		public static const SYN_USER_TEAM_STATE_USERCMD:uint = 4;
		public static const SET_MEMBER_TO_LEADER_USERCMD:uint = 5;
		public static const NOTIFY_MEMBER_LEADER_CHANGE_USERCMD:uint = 6 ;

		public function stTeamCmd()
		{
			super();
			byCmd = stNullUserCmd.TEAM_USERCMD;
		}
	}
}

//struct stTeamCmd : public stNullUserCmd
//{
//	stTeamCmd()
//	{
//		byCmd = TEAM_USERCMD; //21
//	}
//};