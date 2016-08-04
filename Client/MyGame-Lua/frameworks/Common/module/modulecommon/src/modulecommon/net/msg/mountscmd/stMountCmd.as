package modulecommon.net.msg.mountscmd
{
	import common.net.msg.basemsg.stNullUserCmd;
	//import flash.utils.ByteArray;
	
	/**
	 * @brief 坐骑指令
	 */
	public class stMountCmd extends stNullUserCmd
	{
		public static const PARA_MOUNT_SYS_INFO_CMD:uint = 1;
		public static const PARA_NOTIFY_TRAINPROPS_CMD:uint = 2;
		public static const PARA_NOTIFY_MOUNT_PROPS_CMD:uint = 3;
		public static const PARA_ACTIVE_MOUNT_CMD:uint = 4;
		public static const PARA_ADD_MOUNT_TO_USER_CMD:uint = 5;
		public static const PARA_MOUNT_ADVANCE_CMD:uint = 6;
		public static const PARA_MOUNTSYS_PROP_TRAIN_CMD:uint = 7;
		public static const PARA_REFRESH_TRAIN_PROP_CMD:uint = 8;
		public static const PARA_CHANGE_USERMOUNT_CMD:uint = 9;
		public static const PARA_NOTIFY_CHANGE_MOUNT_CMD:uint = 10;
		public static const PARA_SET_RIDE_MOUNT_STATE_CMD:uint = 11;
		public static const PARA_REFRESH_FREE_MOUNT_TRAINTIMES_CMD:uint = 12;
		public static const PARA_VIEW_OTHER_USER_MOUNT_CMD:uint = 13;
		public static const GM_PARA_VIEW_OTHER_USER_MOUNT_CMD:uint = 14;

		public function stMountCmd() 
		{
			super();
			byCmd = stNullUserCmd.MOUNT_USERCMD;
		}
	}
}

///坐骑相关指令
//const BYTE MOUNT_USERCMD = 26;
//struct stMountCmd : public stNullUserCmd
//{
//	stMountCmd()
//	{
//		byCmd = MOUNT_USERCMD;
//	}
//};