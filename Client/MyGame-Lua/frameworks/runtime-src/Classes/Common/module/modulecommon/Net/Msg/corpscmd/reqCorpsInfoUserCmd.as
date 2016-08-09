package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class reqCorpsInfoUserCmd extends stCorpsCmd 
	{
		public var corpsid:uint;
		public function reqCorpsInfoUserCmd() 
		{
			byParam = REQ_CORPS_INFO_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(corpsid);
		}
	}

}

//请求我的军团信息 c->s
	/*const BYTE REQ_CORPS_INFO_USERCMD = 16;
	struct reqCorpsInfoUserCmd : public stCorpsCmd
	{
		reqCorpsInfoUserCmd()
		{
			byParam = REQ_CORPS_INFO_USERCMD;
			corpsid = 0;
		}
		DWORD corpsid;
	};*/
