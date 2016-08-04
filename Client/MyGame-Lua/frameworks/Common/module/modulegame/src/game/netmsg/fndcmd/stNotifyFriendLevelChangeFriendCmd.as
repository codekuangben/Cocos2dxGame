package game.netmsg.fndcmd
{
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;

	public class stNotifyFriendLevelChangeFriendCmd extends stFriendCmd
	{
		public var friendid:uint;
		public var level:uint;

		public function stNotifyFriendLevelChangeFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_NOTIFY_FRIEND_LEVEL_CHANGE_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			friendid = byte.readUnsignedInt();
			level = byte.readUnsignedShort();
		}
	}
}

//好友等级变化通知
/*const BYTE PARA_NOTIFY_FRIEND_LEVEL_CHANGE_FRIENDCMD = 12;
struct stNotifyFriendLevelChangeFriendCmd : public stFriendCmd
{
	stNotifyFriendLevelChangeFriendCmd()
	{
		byParam = PARA_NOTIFY_FRIEND_LEVEL_CHANGE_FRIENDCMD;
		friendid = 0;
		level = 0;
	}
	DWORD friendid;
	WORD level;
};*/