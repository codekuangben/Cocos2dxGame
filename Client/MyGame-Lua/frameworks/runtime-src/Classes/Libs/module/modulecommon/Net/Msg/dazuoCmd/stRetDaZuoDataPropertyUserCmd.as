package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetDaZuoDataPropertyUserCmd extends stPropertyUserCmd
	{
		public var xiulianexp:uint;
		public var corpsexp:uint;
		public var xiuliantime:uint;
		public var fuyoutime:uint;
		public var income:uint;
		
		public function stRetDaZuoDataPropertyUserCmd() 
		{
			byParam = PARA_RET_DAZUO_DATA_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			xiulianexp = byte.readUnsignedInt();
			corpsexp = byte.readUnsignedInt();
			xiuliantime = byte.readUnsignedInt();
			fuyoutime = byte.readUnsignedInt();
			income = byte.readUnsignedShort();
		}
	}

}
/*
	//返回请求打坐的数据
    const BYTE PARA_RET_DAZUO_DATA_PROPERTY_USERCMD = 22;
    struct stRetDaZuoDataPropertyUserCmd : public stPropertyUserCmd
    {
        stRetDaZuoDataPropertyUserCmd()
        {
            byParam = PARA_RET_DAZUO_DATA_PROPERTY_USERCMD;
            xiulianexp = corpsexp = xiuliantime = fuyoutime = 0;
            income = 0;
        }
        DWORD xiulianexp;
		DWORD corpsexp; //军团科技经验
        DWORD xiuliantime;
        DWORD fuyoutime;
        WORD income;
    };
*/