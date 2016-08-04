package game.ui.uibenefithall.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stRetRankRewardRankInfoCmd extends stActivityCmd 
	{
		public var day:int;
		public var selfrank:int;
		public var m_NO1User:stNO1UserInfo;
		public function stRetRankRewardRankInfoCmd() 
		{
			super();
			byParam = PARA_RET_RANK_REWARD_RANK_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			day = byte.readUnsignedShort();
			selfrank = byte.readUnsignedInt();
			m_NO1User = new stNO1UserInfo();
			m_NO1User.deserialize(byte);
		}
	}

}

//返回排行榜信息
   /* const BYTE PARA_RET_RANK_REWARD_RANK_INFO_CMD = 25;
    struct stRetRankRewardRankInfoCmd : public stActivityCmd
    {
        stRetRankRewardRankInfoCmd()
        {
            byParam = PARA_RET_RANK_REWARD_RANK_INFO_CMD;
            day = 0;
            selfrank = 0;
        }
        WORD day;
        DWORD selfrank;
        stNO1UserInfo no1user;
    };*/