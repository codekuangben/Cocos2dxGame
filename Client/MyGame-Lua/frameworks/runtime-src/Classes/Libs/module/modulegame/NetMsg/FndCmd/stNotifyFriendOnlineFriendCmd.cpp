package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stNotifyFriendOnlineFriendCmd extends stFriendCmd
	{
		public var friendid:uint;
		public var online:uint;
		
		public function stNotifyFriendOnlineFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_NOTIFY_FRIEND_ONLINE_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			friendid = byte.readUnsignedInt();
			online = byte.readByte();
		}
	}
}

//好友上下线通知
//const BYTE PARA_NOTIFY_FRIEND_ONLINE_FRIENDCMD = 11;
//struct stNotifyFriendOnlineFriendCmd : public stFriendCmd
//{
//	stNotifyFriendOnlineFriendCmd()
//	{
//		byParam = PARA_NOTIFY_FRIEND_ONLINE_FRIENDCMD;
//		friendid = 0;
//		online = 0;
//	}
//	DWORD friendid;
//	BYTE online;	//1-上线 0-下线
//};