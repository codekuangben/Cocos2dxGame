package game.netmsg.fndcmd
{
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;

	public class stFriendMooddiaryChangeFriendCmd extends stFriendCmd
	{
		public var friendid:uint;
		public var mood:String;

		public function stFriendMooddiaryChangeFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_FRIEND_MOODDIARY_CHANGE_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			friendid = byte.readUnsignedInt();
			mood = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
		}
	}
}

//通知好友心情变化
//const BYTE PARA_FRIEND_MOODDIARY_CHANGE_FRIENDCMD = 14;
//struct stFriendMooddiaryChangeFriendCmd : public stFriendCmd
//{
//	stFriendMooddiaryChangeFriendCmd()
//	{
//		byParam = PARA_FRIEND_MOODDIARY_CHANGE_FRIENDCMD;
//		friendid = 0;
//	}
//	DWORD friendid;
//	char mood[MAX_MOODDIARY_LEN];
//};