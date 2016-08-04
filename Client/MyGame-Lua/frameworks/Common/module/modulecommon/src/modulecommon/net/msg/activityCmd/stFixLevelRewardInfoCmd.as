package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class stFixLevelRewardInfoCmd extends stActivityCmd 
	{
		public var m_dic:Dictionary;
		public function stFixLevelRewardInfoCmd() 
		{
			super();
			byParam = PARA_FIX_LEVEL_REWARD_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_dic = new Dictionary();
			var item:stFixLevelRewardInfo;
			var i:int;
			for (i = 0; i < 3; i++)
			{
				item = new stFixLevelRewardInfo();
				item.deserialize(byte);
				m_dic[item.m_day] = item;
			}
		}
		
	}

}

//固定等级奖励信息
    /*struct stFixLevelRewardInfo
    {   
        WORD day;   //第几日排行榜;
        DWORD level;    //冲榜到达的最高等级
        DWORD rewardflag;   //奖励
    };  

    //全民冲榜上线信息
    const BYTE PARA_FIX_LEVEL_REWARD_INFO_CMD = 21; 
    struct stFixLevelRewardInfoCmd : public stActivityCmd
    {   
        stFixLevelRewardInfo()
        {   
            byParam = PARA_FIX_LEVEL_REWARD_INFO_CMD;
            bzero(rankinfo,sizeof(rankinfo));
        }   
        stFixLevelRewardInfo rankinfo[3];
    }; */