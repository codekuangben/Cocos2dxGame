package modulecommon.net.msg.teamUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqAddMultiCopyUserCmd extends stCopyUserCmd
	{
		public var copytempid:uint;
		public var type:uint;
		public function reqAddMultiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_ADD_MULTI_COPY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(copytempid);
			byte.writeByte(type);
		}
	}
}

//请求加入别人创建的多人副本
//const BYTE REQ_ADD_MULTI_COPY_USERCMD = 41;
//struct reqAddMultiCopyUserCmd : public stCopyUserCmd
//{
//	reqAddMultiCopyUserCmd()
//	{
//		byParam = REQ_ADD_MULTI_COPY_USERCMD;
//		copytempid = 0;
//		type = 0;
//	}
//	DWORD copytempid;
//	BYTE type; //0:使用收益 1:不使用收益
//};