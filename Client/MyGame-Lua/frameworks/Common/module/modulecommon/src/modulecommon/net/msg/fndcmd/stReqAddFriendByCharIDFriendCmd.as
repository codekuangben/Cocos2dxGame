package modulecommon.net.msg.fndcmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	/**
	 * @brief 发送和返回都用这个消息
	 * */
	public class stReqAddFriendByCharIDFriendCmd extends stFriendCmd
	{
		public var charid:uint;
		public var result:uint;
		
		public function stReqAddFriendByCharIDFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_REQ_ADD_FRIEND_BY_CHARID_FRIENDCMD;
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

//请求加好友(通过charid加)
//const BYTE PARA_REQ_ADD_FRIEND_BY_CHARID_FRIENDCMD = 4;
//struct stReqAddFriendByCharIDFriendCmd : public stFriendCmd
//{
//	stReqAddFriendByCharIDFriendCmd()
//	{
//		byParam = PARA_REQ_ADD_FRIEND_BY_CHARID_FRIENDCMD;
//		charid = 0;
//		result = 0;
//	}
//	DWORD charid;
//	BYTE result;	//0-失败 1-成功
//};