package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stBuyFuYouExpPropertyUserCmd extends stPropertyUserCmd
	{
		public var otheruser:uint;
		public var hour:uint;
		
		public function stBuyFuYouExpPropertyUserCmd() 
		{
			byParam = PARA_BUY_FUYOUEXP_PROPERTY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeUnsignedInt(otheruser);
			byte.writeShort(hour);
		}
	}

}

/*
	//够买浮游经验
    const BYTE PARA_BUY_FUYOUEXP_PROPERTY_USERCMD = 27; 
    struct stBuyFuYouExpPropertyUserCmd : public stPropertyUserCmd
    {   
        stBuyFuYouExpPropertyUserCmd()
        {   
            byParam = PARA_BUY_FUYOUEXP_PROPERTY_USERCMD;
            otheruser = 0;
            hour = 0;
        }   
        DWORD otheruser;    //另一玩家的thisid
        WORD hour;
    };  
*/