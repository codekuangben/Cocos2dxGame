package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetBeginWuNvDancingUserCmd extends stWuNvCmd 
	{
		public static const POS_NONE:int = 3;
		public var m_id:uint;
		public var m_tempid:uint;
		public var m_pos:uint;	
		public function stRetBeginWuNvDancingUserCmd() 
		{
			super();
			byParam = RET_BEGIN_WU_NV_DANCING_USERCMD;
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_id = byte.readUnsignedInt();
			m_tempid = byte.readUnsignedInt();
			m_pos = byte.readUnsignedByte();			
		}
	}

}
/*	//返回请求宴请一个舞女开始跳舞 s->c
    const BYTE RET_BEGIN_WU_NV_DANCING_USERCMD = 5;
    struct stRetBeginWuNvDancingUserCmd : public stWuNvCmd
    {   
        stRetBeginWuNvDancingUserCmd()
        {   
            byParam = RET_BEGIN_WU_NV_DANCING_USERCMD;
            id =tempid = 0;
            pos = 0;
        }   
        DWORD id; 
        DWORD tempid; //舞女临时id
        BYTE pos; //参考 struct DancingWuNv.index
    };  
*/