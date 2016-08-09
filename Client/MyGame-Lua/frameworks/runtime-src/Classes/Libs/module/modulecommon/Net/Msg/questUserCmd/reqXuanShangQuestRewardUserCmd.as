package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class reqXuanShangQuestRewardUserCmd extends stQuestUserCmd
	{
		
		public function reqXuanShangQuestRewardUserCmd() 
		{
			byParam = QuestUserParam.REQ_XUAN_SHANG_QUEST_REWARD_PARA;
		}
		
	}

}

/*
    //请求领取奖励
    const BYTE REQ_XUAN_SHANG_QUEST_REWARD_PARA = 16; 
    struct reqXuanShangQuestRewardUserCmd : public stQuestUserCmd
    {   
        reqXuanShangQuestRewardUserCmd()
        {   
            byParam = REQ_XUAN_SHANG_QUEST_REWARD_PARA;
        }   
    };  
*/