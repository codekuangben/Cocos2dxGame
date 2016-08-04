package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqStealWuNvOutPutUserCmd extends stWuNvCmd 
	{
		public var m_friendid:int;
		public var m_tempid:int;
		public function stReqStealWuNvOutPutUserCmd() 
		{
			super();
			byParam = REQ_STEAL_WU_NV_OUT_PUT_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_friendid);
			byte.writeUnsignedInt(m_tempid);
		}
		
	}

}
/*//请求偷窃好友舞女跳舞产出物 c->s
    const BYTE REQ_STEAL_WU_NV_OUT_PUT_USERCMD = 12; 
    struct stReqStealWuNvOutPutUserCmd : public stWuNvCmd
    {   
        stReqStealWuNvOutPutUserCmd()
        {   
            byParam = REQ_STEAL_WU_NV_OUT_PUT_USERCMD;
            friendid = tempid = 0;
        }   
        DWORD friendid;
        DWORD tempid;
    };  
*/