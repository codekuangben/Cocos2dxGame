package modulecommon.net.msg.ingotbefall 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stCaiShenOnlinePropertyUserCmd extends stPropertyUserCmd
	{
		public var lefttimes:uint;
		public var power:uint;
		public var needmoney:uint;
		
		public function stCaiShenOnlinePropertyUserCmd() 
		{
			byParam = PARA_CAISHEN_ONLINE_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			lefttimes = byte.readUnsignedShort();
			power = byte.readUnsignedShort();
			needmoney = byte.readUnsignedShort();
		}
	}

}
/*
//财神上线数据
    const BYTE PARA_CAISHEN_ONLINE_PROPERTY_USERCMD = 19; 
    struct stCaiShenOnlinePropertyUserCmd : public stPropertyUserCmd
    {   
        stCaiShenOnlinePropertyUserCmd()
        {   
            byParam = PARA_CAISHEN_ONLINE_PROPERTY_USERCMD;
            lefttimes = power = needmoney = 0;
        }   
        WORD lefttimes;
        WORD power;
        WORD needmoney;
    };  
*/