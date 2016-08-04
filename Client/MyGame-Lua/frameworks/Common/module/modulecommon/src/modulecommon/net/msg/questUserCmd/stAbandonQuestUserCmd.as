package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * 玩家主动放弃一个任务时，向Server发送这个消息
	 * 服务器要删除一个任务时，向Client发送这个消息
	 * @author zouzhiqiang
	 */

	public class stAbandonQuestUserCmd extends stQuestUserCmd 
	{
		
		public function stAbandonQuestUserCmd() 
		{
			byParam = QuestUserParam.ABANDON_QUEST_PARA;
		}
		
	}

	/*
	 * const BYTE ABANDON_QUEST_PARA = 4;
	struct stAbandonQuestUserCmd : public stQuestUserCmd
	{
	  stAbandonQuestUserCmd()
	  {
	      byParam = ABANDON_QUEST_PARA;
	    }
	};
	 */
}