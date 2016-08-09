package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stSaleFuYouExpToSysPropertyUserCmd extends stPropertyUserCmd
	{
		public var hour:uint;	//时间大小(小时)
		
		public function stSaleFuYouExpToSysPropertyUserCmd() 
		{
			byParam = PARA_SALEFUYOUEXP_TO_SYS_PROPERTY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(hour);
		}
	}

}

/*
	//卖浮游经验给系统
    const BYTE PARA_SALEFUYOUEXP_TO_SYS_PROPERTY_USERCMD = 25;
    struct stSaleFuYouExpToSysPropertyUserCmd : public stPropertyUserCmd
    {
        stSaleFuYouExpToSysPropertyUserCmd()
        {
            byParam = PARA_SALEFUYOUEXP_TO_SYS_PROPERTY_USERCMD;
            hour = 0;
        }
        DWORD hour;
    };
*/