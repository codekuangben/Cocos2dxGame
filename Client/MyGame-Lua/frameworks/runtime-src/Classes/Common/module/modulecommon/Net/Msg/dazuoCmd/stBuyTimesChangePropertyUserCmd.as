package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stBuyTimesChangePropertyUserCmd extends stPropertyUserCmd
	{
		public var buytimes:uint;
		
		public function stBuyTimesChangePropertyUserCmd() 
		{
			byParam = PARA_BUYTIMES_CHANGE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			buytimes = byte.readUnsignedShort();
		}
	}

}

/*
	//购买次数变化
    const BYTE PARA_BUYTIMES_CHANGE_PROPERTY_USERCMD = 29;
    struct stBuyTimesChangePropertyUserCmd : public stPropertyUserCmd
    {
        stBuyTimesChangePropertyUserCmd()
        {
            byParam = PARA_BUYTIMES_CHANGE_PROPERTY_USERCMD;
            buytimes = 0;
        }
        WORD buytimes;
    };
*/