package game.netmsg.corpscmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;

	public class retJoinCorpsUserCmd extends stCorpsCmd
	{
		public var type:uint;
		
		public function retJoinCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.RET_JOIN_CORPS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
		}
	}
}

//返回请求加入军团 s->c
//const BYTE RET_JOIN_CORPS_USERCMD = 6;
//struct retJoinCorpsUserCmd : public stCorpsCmd
//{
//	retJoinCorpsUserCmd()
//	{
//		byParam = RET_JOIN_CORPS_USERCMD;
//		type = 0;
//	}
//	BYTE type; //成功 :1, 拒绝:0
//};