package game.ui.tongquetai.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqBeginWuNvDancingUserCmd extends stWuNvCmd 
	{
		public var m_pos:int;
		public var m_id:int;
		public function stReqBeginWuNvDancingUserCmd() 
		{
			super();
			byParam = REQ_BEGIN_WU_NV_DANCING_USERCMD;
			
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_pos);
			byte.writeUnsignedInt(m_id);
		}
		
	}

}
/*//请求宴请一个舞女开始跳舞 c->s
	const BYTE REQ_BEGIN_WU_NV_DANCING_USERCMD = 4;
    struct stReqBeginWuNvDancingUserCmd : public stWuNvCmd
    {   
        stReqBeginWuNvDancingUserCmd()
        {   
            byParam = REQ_BEGIN_WU_NV_DANCING_USERCMD;
            pos = 0;
            id = 0;
        }   
        BYTE pos;
        DWORD id; //舞女id
    };  
*/