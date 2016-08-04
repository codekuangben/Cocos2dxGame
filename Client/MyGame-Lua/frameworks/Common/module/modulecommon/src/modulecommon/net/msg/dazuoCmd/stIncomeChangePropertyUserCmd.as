package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stIncomeChangePropertyUserCmd extends stPropertyUserCmd
	{
		public var income:uint;
		
		public function stIncomeChangePropertyUserCmd() 
		{
			byParam = PARA_INCOME_CHANGE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			income = byte.readUnsignedShort();
		}
	}

}

/*
	//收益变化
    const BYTE PARA_INCOME_CHANGE_PROPERTY_USERCMD = 28;
    struct stIncomeChangePropertyUserCmd : public stPropertyUserCmd
    {
        stIncomeChangePropertyUserCmd()
        {
            byParam = PARA_INCOME_CHANGE_PROPERTY_USERCMD;
            income = 0;
        }
        WORD income;
    };
*/