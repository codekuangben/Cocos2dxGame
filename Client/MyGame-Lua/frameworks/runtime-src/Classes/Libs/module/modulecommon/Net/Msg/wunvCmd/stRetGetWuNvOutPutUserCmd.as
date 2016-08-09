package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author ...
	 */
	public class stRetGetWuNvOutPutUserCmd extends stWuNvCmd 
	{
		public var m_tempid:uint;
		public var m_ret:uint;
		public function stRetGetWuNvOutPutUserCmd() 
		{
			super();
			byParam = RET_GET_WU_NV_OUT_PUT_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_tempid = byte.readUnsignedInt();
			m_ret = byte.readUnsignedByte();
		}
		
	}

}
/*//返回请求领取舞女跳舞产出物 s->c
	const BYTE RET_GET_WU_NV_OUT_PUT_USERCMD = 11;
	struct stRetGetWuNvOutPutUserCmd : public stWuNvCmd
	{
		stRetGetWuNvOutPutUserCmd()
		{
			byParam = RET_GET_WU_NV_OUT_PUT_USERCMD;
			ret = 0;
			tempid = 0;
		}
		DWORD tempid;
		BYTE ret; //0:成功 1:失败
	};*/