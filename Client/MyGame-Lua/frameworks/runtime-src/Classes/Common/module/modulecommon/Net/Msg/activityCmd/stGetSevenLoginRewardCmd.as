package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stGetSevenLoginRewardCmd extends stActivityCmd 
	{
		public var day:uint;
		public function stGetSevenLoginRewardCmd() 
		{
			super();
			byParam = PARA_GET_SEVEN_LOGIN_REWARD_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(day);
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			day = byte.readUnsignedByte();
		}
	}

}

//领取七日登陆奖励
    /*const BYTE PARA_GET_SEVEN_LOGIN_REWARD_CMD = 20; 
    struct stGetSevenLoginRewardCmd : public stActivityCmd
    {   
        stGetSevenLoginRewardCmd()
        {   
            byParam = PARA_GET_SEVEN_LOGIN_REWARD_CMD;
            day = 0;
        }
        BYTE day;
    };*/