package modulecommon.net.msg.fndcmd
{
	import common.net.msg.basemsg.stNullUserCmd;

	public class stFriendCmd extends stNullUserCmd
	{
		public static const PARA_FRIEND_LIST_FRIENDCMD:uint = 1;
		public static const PARA_BLACK_LIST_FRIENDCMD:uint = 2;
		public static const PARA_FRIEND_APPLY_LIST_FRIENDCMD:uint = 3;
		public static const PARA_REQ_ADD_FRIEND_BY_CHARID_FRIENDCMD:uint = 4;
		public static const PARA_REQ_ADD_FRIEND_BY_NAME_FRIENDCMD:uint = 5;
		public static const PARA_RET_ADD_FRIEND_BY_NAME_FRIENDCMD:uint = 6;
		public static const PARA_RET_FRIEND_BASEINFO_FRIENDCMD:uint = 7;
		public static const PARA_MOVE_FRIEND_TO_BLACKLIST_FRIENDCMD:uint = 8;
		public static const PARA_DELETE_FRIEND_FRIENDCMD:uint = 9;
		public static const PARA_NOTIFY_FRIEND_APPLY_FRIENDCMD:uint = 10;
		public static const PARA_NOTIFY_FRIEND_ONLINE_FRIENDCMD:uint = 11;
		public static const PARA_NOTIFY_FRIEND_LEVEL_CHANGE_FRIENDCMD:uint = 12;
		public static const PARA_WRITE_MOODDIARY_FRIENDCMD:uint = 13;
		public static const PARA_FRIEND_MOODDIARY_CHANGE_FRIENDCMD:uint = 14;
		public static const PARA_HANDLE_FRIEND_APPLY_FRIENDCMD:uint = 15;
		public static const PARA_BAT_HANDLE_FRIEND_APPLY_FRIENDCMD:uint = 16;
		public static const PARA_VIEW_FRIEND_DATA_FRIENDCMD:uint = 17;
		public static const PARA_SELF_INFO_FRIENDCMD:uint = 18;
		public static const PARA_RET_BLACK_BASEINFO_FRIENDCMD:uint = 19;
		public static const PARA_FRIENDBLESS_INFO_FRIENDCMD:uint = 20;
		public static const PARA_FRIENDBLESS_FRIENDCMD:uint = 21;
		public static const PARA_FRIEND_FOCUS_CHANGE_FRIENDCMD:uint = 22;
		public static const PARA_MOVE_USER_TO_BLACKLIST_FRIENDCMD:uint = 23;
		public static const REQ_AUTO_ADD_FRIEND_FRIENDCMD:uint = 24;
		public static const PARA_HELP_FRIEND_ID_FRIENDCMD:uint = 25;
		
		public static const PARA_FRIEND_HELP_QBTIMES_FRIENDCMD:uint = 26;
		public static const PARA_REQ_HELPME_QB_FRIENDLIST_FRIENDCMD:uint = 27;
		public static const PARA_RET_HELPME_QB_FRIENDLIST_FRIENDCMD:uint = 28;
		public static const PARA_REFRESH_HELP_QB_FRIENDLIST_FRIENDCMD:uint = 29;		
		public static const PARA_REQ_HAS_HELPSTATE_FRIENDLIST_FRIENDCMD:uint = 30;
		public static const PARA_RET_HAS_HELPSTATE_FRIENDLIST_FRIENDCMD:uint = 31;
		public static const PARA_HELP_FRIEND_QB_FRIENDCMD:uint = 32;
		public static const PARA_REQ_FRIEND_HELP_QB_FRIENDCMD:uint = 33;
		public static const PARA_NOTIFY_FRIEND_ROBBED_FRIENDCMD:uint = 34;
		
		public function stFriendCmd()
		{
			super();
			byCmd = stNullUserCmd.FRIEND_USERCMD;
		}
	}
}
 
//好友相关指令
//struct stFriendCmd : public stNullUserCmd
//{
//	stFriendCmd()
//	{
//		byCmd = FRIEND_USERCMD;
//	}
//};