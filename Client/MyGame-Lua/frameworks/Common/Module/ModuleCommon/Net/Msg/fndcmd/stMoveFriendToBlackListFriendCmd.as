package modulecommon.net.msg.fndcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stMoveFriendToBlackListFriendCmd extends stFriendCmd
	{
		public var charid:uint;
		public var result:uint;
		
		public function stMoveFriendToBlackListFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_MOVE_FRIEND_TO_BLACKLIST_FRIENDCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(charid);
			byte.writeByte(result);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			charid = byte.readUnsignedInt();
			result = byte.readUnsignedByte();
		}
	}
}

//将好友拉黑
//const BYTE PARA_MOVE_FRIEND_TO_BLACKLIST_FRIENDCMD = 8;
//struct stMoveFriendToBlackListFriendCmd : public stFriendCmd
//{
//	stMoveFriendToBlackListFriendCmd()
//	{
//		byParam = PARA_MOVE_FRIEND_TO_BLACKLIST_FRIENDCMD;
//		charid = 0;
//		result = 0;
//	}
//	DWORD charid;
//	BYTE result;	//0-失败 1-成功
//};