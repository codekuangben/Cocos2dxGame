package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 * 元宝加速
	 */
	public class stReqYuanBaoCoolingUserCmd extends stCopyUserCmd 
	{
		public static const CANGBAOKU_PK:uint = 1;
		public static const GUANZHIJINGJI_PK:uint = 2;
		
		public var m_type:uint;
		
		public function stReqYuanBaoCoolingUserCmd() 
		{
			byParam = REQ_YUAN_BAO_COOLING_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(m_type);
		}
	}

}

/*
	const BYTE CANGBAOKU_PK = 1;
    const BYTE GUANZHIJINGJI_PK = 2;

    const BYTE  REQ_YUAN_BAO_COOLING_USERCMD = 32; 
    struct  stReqYuanBaoCoolingUserCmd: public stCopyUserCmd
    {   
        stReqYuanBaoCoolingUserCmd()
        {   
            byParam = REQ_YUAN_BAO_COOLING_USERCMD;
            type = 0;
        }   
        BYTE type;
    };  
*/