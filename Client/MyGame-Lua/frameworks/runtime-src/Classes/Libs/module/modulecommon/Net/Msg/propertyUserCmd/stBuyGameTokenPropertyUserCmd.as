package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stBuyGameTokenPropertyUserCmd extends stPropertyUserCmd
	{
		public var type:int;
		public var value:uint;
		
		public function stBuyGameTokenPropertyUserCmd() 
		{
			byParam = PARA_BUY_GAMETOKEN_PROPERTY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeByte(type);
			byte.writeUnsignedInt(value);
		}
	}

}

/*
//购买游戏代币
    const BYTE PARA_BUY_GAMETOKEN_PROPERTY_USERCMD = 30; 
    struct stBuyGameTokenPropertyUserCmd : public stPropertyUserCmd
    {   
        stBuyGameTokenPropertyUserCmd()
        {   
            byParam = PARA_BUY_GAMETOKEN_PROPERTY_USERCMD;
            type = 0;
            value = 0;
        }   
        BYTE type;
        DWORD value;
    };
*/