package modulecommon.net.msg.mailCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqMailListCmd extends stMailCmd 
	{
		
		public function stReqMailListCmd() 
		{
			byParam = REQ_MAIL_LIST_USERCMD;
		}
		
	}

}

//请求邮件列表
	/*const BYTE REQ_MAIL_LIST_USERCMD = 1;
	struct stReqMailListCmd : public stMailCmd
	{
		stReqMailListCmd()
		{
			byParam = REQ_MAIL_LIST_USERCMD;
		}
	};*/