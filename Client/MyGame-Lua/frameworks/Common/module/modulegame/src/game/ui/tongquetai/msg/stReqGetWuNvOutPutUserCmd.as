package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqGetWuNvOutPutUserCmd extends stWuNvCmd 
	{
		public var m_tempid:int;
		public function stReqGetWuNvOutPutUserCmd() 
		{
			super();
			byParam = REQ_GET_WU_NV_OUT_PUT_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_tempid);
		}
		
	}

}
/*	//请求领取舞女跳舞产出物 c->s
	const BYTE REQ_GET_WU_NV_OUT_PUT_USERCMD = 10;
	struct stReqGetWuNvOutPutUserCmd : public stWuNvCmd
	{
		stReqGetWuNvOutPutUserCmd()
		{
			byParam = REQ_GET_WU_NV_OUT_PUT_USERCMD;
			tempid = 0;
		}
		DWORD tempid;
	};*/