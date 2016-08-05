package modulecommon.net.msg.copyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public class stReqAvailableCopyUserCmd extends stCopyUserCmd 
	{		
		public var id:uint;
		public function stReqAvailableCopyUserCmd() 
		{
			byParam = REQ_AVAILABLE_COPY_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(id);
		}		
	}

}

//请求可用副本
	/*const BYTE  REQ_AVAILABLE_COPY_USERCMD = 4;
	struct  stReqAvailableCopyUserCmd: public stCopyUserCmd
	{
		stReqAvailableCopyUserCmd()
		{
			byParam = REQ_AVAILABLE_COPY_USERCMD;
		}
	};*/