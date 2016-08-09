package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stSetDaZuoStatePropertyUserCmd extends stPropertyUserCmd
	{
		public var isset:uint;
		
		public function stSetDaZuoStatePropertyUserCmd() 
		{
			byParam = PARA_SET_DAZUOSTATE_PROPERTY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			
			byte.writeByte(isset);
		}
	}

}

/*
	//设置打坐状态
    const BYTE PARA_SET_DAZUOSTATE_PROPERTY_USERCMD = 21;
    struct stSetDaZuoStatePropertyUserCmd : public stPropertyUserCmd
    {
        stSetDaZuoStatePropertyUserCmd()
        {
            byParam = PARA_SET_DAZUOSTATE_PROPERTY_USERCMD;
            isset = 0;
        }
        BYTE isset; //0-取消 1-打坐
    };
*/