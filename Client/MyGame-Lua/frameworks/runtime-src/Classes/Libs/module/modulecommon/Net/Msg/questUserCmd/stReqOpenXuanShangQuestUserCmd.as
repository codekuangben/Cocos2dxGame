package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqOpenXuanShangQuestUserCmd extends stQuestUserCmd
	{
		
		public function stReqOpenXuanShangQuestUserCmd() 
		{
			byParam = QuestUserParam.REQ_OPEN_XUAN_SHANG_QUEST_PARA;
		}
		
	}

}

/*
	//请求打开悬赏任务界面
	const BYTE REQ_OPEN_XUAN_SHANG_QUEST_PARA = 6;
    struct stReqOpenXuanShangQuestUserCmd : public stQuestUserCmd
    {   
        stReqOpenXuanShangQuestUserCmd()
        {   
            byParam = REQ_OPEN_XUAN_SHANG_QUEST_PARA;
        }   
    };  
*/