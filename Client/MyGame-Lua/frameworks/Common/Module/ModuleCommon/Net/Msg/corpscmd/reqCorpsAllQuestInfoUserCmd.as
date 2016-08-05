package modulecommon.net.msg.corpscmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class reqCorpsAllQuestInfoUserCmd extends stCorpsCmd 
	{
		
		public function reqCorpsAllQuestInfoUserCmd() 
		{
			byParam = REQ_CORPS_ALL_QUEST_INFO_USERCMD;
		}
		
	}

}

//返回所有军团任务信息 s->c
	/*const BYTE REQ_CORPS_ALL_QUEST_INFO_USERCMD = 40;
	struct reqCorpsAllQuestInfoUserCmd : public stCorpsCmd
	{
		reqCorpsAllQuestInfoUserCmd()
		{
			byParam = REQ_CORPS_ALL_QUEST_INFO_USERCMD;
		}
	};*/