package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stFuYouTimeChangePropertyUserCmd extends stPropertyUserCmd
	{
		public var fuyoutime:uint;
		
		public function stFuYouTimeChangePropertyUserCmd() 
		{
			byParam = PARA_FUYOUTIME_CHANGE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			fuyoutime = byte.readUnsignedInt();
		}
	}

}

/*
	//浮游时间变化
    const BYTE PARA_FUYOUTIME_CHANGE_PROPERTY_USERCMD = 26;
    struct stFuYouTimeChangePropertyUserCmd : public stPropertyUserCmd
    {
        stFuYouTimeChangePropertyUserCmd()
        {
            byParam = PARA_FUYOUTIME_CHANGE_PROPERTY_USERCMD;
            fuyoutime = 0;
        }
        DWORD fuyoutime;
    };
*/