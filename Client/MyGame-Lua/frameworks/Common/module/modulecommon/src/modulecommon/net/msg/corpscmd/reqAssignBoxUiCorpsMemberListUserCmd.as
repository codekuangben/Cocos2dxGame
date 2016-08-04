package modulecommon.net.msg.corpscmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class reqAssignBoxUiCorpsMemberListUserCmd extends stCorpsCmd
	{
		
		public function reqAssignBoxUiCorpsMemberListUserCmd() 
		{
			byParam = REQ_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD;
		}
		
	}

}

/*
//请求分配争霸宝箱界面成员信息 c->s
	const BYTE REQ_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD = 55;
	struct reqAssignBoxUiCorpsMemberListUserCmd : public stCorpsCmd
	{
		reqAssignBoxUiCorpsMemberListUserCmd()
		{
			byParam = REQ_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD;
		}
	};
*/