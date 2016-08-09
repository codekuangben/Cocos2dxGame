package modulecommon.net.msg.corpscmd
{
	import flash.utils.ByteArray;	

	public class reqJoinCorpsUserCmd extends stCorpsCmd
	{
		public var corpsid:uint;
		public function reqJoinCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.REQ_JOIN_CORPS_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(corpsid);
		}
	}
}

//请求加入军团 c->s
//const BYTE REQ_JOIN_CORPS_USERCMD = 5;
//struct reqJoinCorpsUserCmd : public stCorpsCmd
//{
//	reqJoinCorpsUserCmd()
//	{
//		byParam = REQ_JOIN_CORPS_USERCMD;
//		corpsid = 0;
//	}
//	DWORD corpsid;
//};