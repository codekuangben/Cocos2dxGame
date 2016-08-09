package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 玩家上线的时候发这个消息，客户端收到这个消息表明已经客户端已经接收到了所有任务
	 */
	public class stSynQuestDataFinQuestUserCmd extends stQuestUserCmd 
	{
		
		public function stSynQuestDataFinQuestUserCmd() 
		{
			byParam = QuestUserParam.SYN_QUEST_DATA_FIN_PARA;
		}
		
	}

}

/*
 * const BYTE SYN_QUEST_DATA_FIN_PARA = 5;
    struct stSynQuestDataFinQuestUserCmd : public stQuestUserCmd
    {   
        stSynQuestDataFinQuestUserCmd()
        {   
            byParam = SYN_QUEST_DATA_FIN_PARA;
        }   
    };
*/