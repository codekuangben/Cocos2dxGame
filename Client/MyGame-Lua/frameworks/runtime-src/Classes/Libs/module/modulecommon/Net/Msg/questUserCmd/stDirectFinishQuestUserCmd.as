package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stDirectFinishQuestUserCmd extends stQuestUserCmd
	{
		
		public function stDirectFinishQuestUserCmd() 
		{
			byParam = QuestUserParam.DIRECT_FINISH_QUEST_PARA;
		}
		
	}

}

/*
	//请求直接完成
    const BYTE DIRECT_FINISH_QUEST_PARA = 15;
    struct stDirectFinishQuestUserCmd : public stQuestUserCmd
    {           
        stDirectFinishQuestUserCmd()
        {
            byParam = DIRECT_FINISH_QUEST_PARA;
        }                       
    };  
*/