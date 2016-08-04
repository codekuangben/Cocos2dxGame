package modulecommon.net.msg.ingotbefall 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetZhaoCaiResultPropertyUserCmd extends stPropertyUserCmd
	{
		public var baoji:uint;
		public var power:uint;
		public var money:uint;
		public var lefttimes:uint;
		
		public function stRetZhaoCaiResultPropertyUserCmd() 
		{
			byParam = PARA_RET_ZHAOCAI_RESULT_PROPERTY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			baoji = byte.readUnsignedByte();
			power = byte.readUnsignedShort();
			money = byte.readUnsignedShort();
			lefttimes = byte.readUnsignedShort();
		}
	}

}
/*
//财神返回消息
    const BYTE PARA_RET_ZHAOCAI_RESULT_PROPERTY_USERCMD = 18; 
    struct stRetZhaoCaiResultPropertyUserCmd : public stPropertyUserCmd
    {   
        stRetZhaoCaiResultPropertyUserCmd()
        {   
            byParam = PARA_RET_ZHAOCAI_RESULT_PROPERTY_USERCMD;
            baoji = 0;
            power = money = 0;
        }   
        BYTE baoji; //是否暴击 0-否 1-暴击
        WORD power; //招财能量
        WORD money; //所需元宝
		WORD lefttimes;	//剩余次数
    };
*/