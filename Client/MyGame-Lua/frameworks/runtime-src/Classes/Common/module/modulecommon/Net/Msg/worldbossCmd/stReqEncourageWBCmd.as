package modulecommon.net.msg.worldbossCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqEncourageWBCmd extends stWorldBossCmd
	{
		
		public function stReqEncourageWBCmd() 
		{
			byParam = PARA_REQ_ENCOURAGE_WBCMD;
		}
		
	}

}
/*
	//请求激励
	const BYTE PARA_REQ_ENCOURAGE_WBCMD = 12;
	struct stReqEncourageWBCmd : public stWorldBossCmd
	{
		stReqEncourageWBCmd()
		{
			byParam = PARA_REQ_ENCOURAGE_WBCMD;
		}
	};
*/