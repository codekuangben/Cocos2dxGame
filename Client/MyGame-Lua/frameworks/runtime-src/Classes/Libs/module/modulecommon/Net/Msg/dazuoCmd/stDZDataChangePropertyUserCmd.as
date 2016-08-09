package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stDZDataChangePropertyUserCmd extends stPropertyUserCmd
	{
		public var xiulianexp:uint;
		public var corpsexp:uint;
		public var xiuliantime:uint;
		public var fuyoutime:uint;
		
		public function stDZDataChangePropertyUserCmd() 
		{
			byParam = PARA_DZDATA_CHANGE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			xiulianexp = byte.readUnsignedInt();
			corpsexp = byte.readUnsignedInt();
			xiuliantime = byte.readUnsignedInt();
			fuyoutime = byte.readUnsignedShort();
		}
	}

}

/*
	//打坐数据变化
    const BYTE PARA_DZDATA_CHANGE_PROPERTY_USERCMD = 23;
    struct stDZDataChangePropertyUserCmd : public stPropertyUserCmd
    {
        stDZDataChangePropertyUserCmd()
        {
            byParam = PARA_DZDATA_CHANGE_PROPERTY_USERCMD;
            xiulianexp = corpsexp = xiuliantime = fuyoutime = 0;
        }
        DWORD xiulianexp;
		DWORD corpsexp; //军团科技经验
        DWORD xiuliantime;
        DWORD fuyoutime;
    };
*/