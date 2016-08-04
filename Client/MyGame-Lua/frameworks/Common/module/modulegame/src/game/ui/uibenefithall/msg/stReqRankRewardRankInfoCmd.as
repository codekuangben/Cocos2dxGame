package game.ui.uibenefithall.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stReqRankRewardRankInfoCmd extends stActivityCmd 
	{
		public var day:int;
		public function stReqRankRewardRankInfoCmd() 
		{
			super();
			byParam = PARA_REQ_RANK_REWARD_RANK_INFO_CMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeShort(day);
		}
		
	}

}

/*请求排行榜信息
    const BYTE PARA_REQ_RANK_REWARD_RANK_INFO_CMD = 24;
    struct stReqRankRewardRankInfoCmd : public stActivityCmd
    {
        stReqRankRewardRankInfoCmd()
        {
            byParam = PARA_REQ_RANK_REWARD_RANK_INFO_CMD;
            day = 0;
        }
        WORD day;
    };*/