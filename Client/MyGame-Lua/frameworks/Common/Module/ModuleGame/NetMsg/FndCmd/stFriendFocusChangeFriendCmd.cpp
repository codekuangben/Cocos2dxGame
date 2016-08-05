package game.netmsg.fndcmd
{
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;

	public class stFriendFocusChangeFriendCmd extends stFriendCmd
	{
		public var friendid:uint;
		public var focus:uint;
		
		public function stFriendFocusChangeFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_FRIEND_FOCUS_CHANGE_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			friendid = byte.readUnsignedInt();
			focus = byte.readUnsignedByte();
		}
	}
}

//好友关注变化
//const BYTE PARA_FRIEND_FOCUS_CHANGE_FRIENDCMD = 22; 
//struct stFriendFocusChangeFriendCmd : public stFriendCmd
//{   
//	stFriendFocusChangeFriendCmd()
//	{   
//		byParam = PARA_FRIEND_FOCUS_CHANGE_FRIENDCMD;
//		friendid = 0;
//		focus = 0;
//	}   
//	DWORD friendid;
//	BYTE  focus;    //0- 取消关注 1-关注
//};