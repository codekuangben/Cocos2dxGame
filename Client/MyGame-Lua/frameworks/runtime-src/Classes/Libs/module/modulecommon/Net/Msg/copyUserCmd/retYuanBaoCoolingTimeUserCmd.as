package modulecommon.net.msg.copyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 * 冷却时间更新
	 */
	public class retYuanBaoCoolingTimeUserCmd extends stCopyUserCmd 
	{
		public var type:uint;
		public var time:uint;//单位秒
		public function retYuanBaoCoolingTimeUserCmd() 
		{
			byParam = RET_YUAN_BAO_COOLING_TIME_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			time = byte.readUnsignedInt();
		}		
	}

}

/*
const BYTE  RET_YUAN_BAO_COOLING_TIME_USERCMD = 33; 
    struct  retYuanBaoCoolingTimeUserCmd: public stCopyUserCmd
    {   
        retYuanBaoCoolingTimeUserCmd()
        {   
            byParam = RET_YUAN_BAO_COOLING_TIME_USERCMD;
        }   
        BYTE type;
        DWORD time;
    };  */