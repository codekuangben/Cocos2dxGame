package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stSevenLoginAwardInfoCmd extends stActivityCmd 
	{
		public var logindays:uint;
		public var awardflag:uint;	//按位表示，0位无意义，1位表示第一天
		public function stSevenLoginAwardInfoCmd() 
		{
			super();
			byParam = PARA_SEVEN_LOGIN_AWARD_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			logindays = byte.readUnsignedShort();
			awardflag = byte.readUnsignedShort();
		}
	}

}

//七日登陆奖励信息
    /*const BYTE PARA_SEVEN_LOGIN_AWARD_INFO_CMD = 19; 
    struct stSevenLoginAwardInfoCmd : public stActivityCmd
    {   
        stSevenLoginAwardInfoCmd()
        {   
            byParam = PARA_SEVEN_LOGIN_AWARD_INFO_CMD;
            logindays = awardflag = 0;
        }
        WORD logindays; //登陆的天数
        WORD awardflag; //奖励领取标记
    }; */