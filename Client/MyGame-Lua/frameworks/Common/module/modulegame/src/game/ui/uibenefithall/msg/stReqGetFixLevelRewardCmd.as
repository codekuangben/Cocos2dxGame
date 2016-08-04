package game.ui.uibenefithall.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stReqGetFixLevelRewardCmd extends stActivityCmd 
	{
		public var m_day:int;
		public var m_flag:int;
		public function stReqGetFixLevelRewardCmd() 
		{
			super();
			byParam = PARA_REQ_GET_FIX_LEVEL_REWARD_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(m_day);
			byte.writeShort(m_flag);
		}
	}

}

//请求领取排行榜固定奖励
    /*const BYTE PARA_REQ_GET_FIX_LEVEL_REWARD_CMD = 22; 
    struct stReqGetFixLevelRewardCmd : public stActivityCmd
    {   
        stReqGetFixLevelRewardCmd()
        {   
            byParam = PARA_REQ_GET_FIX_LEVEL_REWARD_CMD;
            day = 0;
        }   
        WORD day;   //第几日
        WORD flag;
    };  */