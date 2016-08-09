package modulecommon.net.msg.fndcmd
{
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;

	public class stDeleteFriendFriendCmd extends stFriendCmd
	{
		public var charid:uint;
		public var type:uint;
		public var result:uint;

		public function stDeleteFriendFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_DELETE_FRIEND_FRIENDCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(charid)
			byte.writeByte(type);
			byte.writeByte(result);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			charid = byte.readUnsignedInt();
			type = byte.readUnsignedByte();
			result = byte.readUnsignedByte();
		}
	}
}

//删除好友
//const BYTE PARA_DELETE_FRIEND_FRIENDCMD = 9;
//struct stDeleteFriendFriendCmd : public stFriendCmd
//{
//	stDeleteFriendFriendCmd()
//	{
//		byParam = PARA_DELETE_FRIEND_FRIENDCMD;
//		charid = 0;
//		result = 0;
//	}
//	DWORD charid;
//	BYTE type;		// 0 - 好友 1 - 黑名单
//	BYTE result;	//0-失败 1-成功
//};