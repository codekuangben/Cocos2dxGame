package game.netmsg.corpscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class retDonateCorpsUserCmd extends stCorpsCmd 
	{
		public var contri:uint;
		public var wuzi:uint;
		public function retDonateCorpsUserCmd() 
		{
			byParam = RET_DONATE_CORPS_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			contri = byte.readUnsignedInt();
			wuzi = byte.readUnsignedInt();
		}
		
	}

}

//捐献返回 s->c
    /*const BYTE RET_DONATE_CORPS_USERCMD = 24; 
    struct retDonateCorpsUserCmd : public stCorpsCmd
    {   
        retDonateCorpsUserCmd()
        {   
            byParam = RET_DONATE_CORPS_USERCMD;
            contri = 0;
            wuzi = 0;
        }   
        DWORD contri;
        DWORD wuzi;
    }; */