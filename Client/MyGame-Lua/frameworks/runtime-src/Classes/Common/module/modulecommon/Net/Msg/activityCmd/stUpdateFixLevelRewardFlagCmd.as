package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stUpdateFixLevelRewardFlagCmd extends stActivityCmd 
	{
		public var day:int;
		public var rewardflag:int;
		public function stUpdateFixLevelRewardFlagCmd() 
		{
			super();
			byParam = PARA_UPDATE_FIX_LEVEL_REWARD_FLAG_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			day = byte.readUnsignedShort();	
			rewardflag = byte.readUnsignedInt();
		}
	}

}

//刷新固定奖励领取信息
    /*const BYTE PARA_UPDATE_FIX_LEVEL_REWARD_FLAG_CMD = 23;
    struct stUpdateFixLevelRewardFlagCmd : public stActivityCmd
    {
        stUpdateFixLevelRewardFlagCmd()
        {
            byParam = PARA_UPDATE_FIX_LEVEL_REWARD_FLAG_CMD;
            day = 0;
            rewardflag = 0;
        }
        WORD day;
		DWORD rewardflag;
    };*/