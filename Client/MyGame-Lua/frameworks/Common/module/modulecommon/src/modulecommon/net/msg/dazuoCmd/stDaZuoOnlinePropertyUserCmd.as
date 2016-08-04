package modulecommon.net.msg.dazuoCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stDaZuoOnlinePropertyUserCmd extends stPropertyUserCmd
	{
		public var state:uint;
		public var xiulianexp:uint;
		public var corpsexp:uint;
		public var xiuliantime:uint;
		public var fuyoutime:uint;
		public var buytime:uint;
		public var income:uint;
		
		public function stDaZuoOnlinePropertyUserCmd() 
		{
			byParam = PARA_DAZUO_ONLINE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			state = byte.readUnsignedByte();
			xiulianexp = byte.readUnsignedInt();
			corpsexp = byte.readUnsignedInt();
			xiuliantime = byte.readUnsignedInt();
			fuyoutime = byte.readUnsignedInt();
			buytime = byte.readUnsignedShort();
			income = byte.readUnsignedShort();
		}
		
	}

}

/*
	//打坐上线数据
    const BYTE PARA_DAZUO_ONLINE_PROPERTY_USERCMD = 20;
    struct stDaZuoOnlinePropertyUserCmd : public stPropertyUserCmd
    {
        stDaZuoOnlinePropertyUserCmd()
        {
            byParam = PARA_DAZUO_ONLINE_PROPERTY_USERCMD;
            state = 0;
            xiulianexp = corpsexp = xiuliantime = fuyoutime = 0;
            buytime = income = 0;
        }
        BYTE state; //打坐状态
        DWORD xiulianexp;
		DWORD corpsexp; //军团科技经验
        DWORD xiuliantime;
        DWORD fuyoutime;
        WORD buytime;   //今日购买过浮游经验的次数(1次/1小时)
        WORD income;    //收益
    };
*/