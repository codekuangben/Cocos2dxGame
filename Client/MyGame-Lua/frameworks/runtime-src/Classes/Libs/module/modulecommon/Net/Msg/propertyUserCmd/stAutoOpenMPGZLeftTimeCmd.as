package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stAutoOpenMPGZLeftTimeCmd extends stPropertyUserCmd 
	{
		public var totaltime:uint;
		public var lefttime:uint;
		public function stAutoOpenMPGZLeftTimeCmd() 
		{
			byParam = PARA_AUTO_OPEN_MPGZ_LEFTTIME_PROPERTY_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			totaltime = byte.readUnsignedInt();
			lefttime = byte.readUnsignedInt();
		}
		
	}

}

//自动开主包裹格子剩余时间
    /*const BYTE PARA_AUTO_OPEN_MPGZ_LEFTTIME_PROPERTY_USERCMD = 35; 
    struct stAutoOpenMPGZLeftTimeCmd : public stPropertyUserCmd
    {   
        stAutoOpenMPGZLeftTimeCmd()
        {   
            byParam = PARA_AUTO_OPEN_MPGZ_LEFTTIME_PROPERTY_USERCMD;
            lefttime = 0;
        }   
		DWORD totaltime;
        DWORD lefttime; //分钟
    }; */