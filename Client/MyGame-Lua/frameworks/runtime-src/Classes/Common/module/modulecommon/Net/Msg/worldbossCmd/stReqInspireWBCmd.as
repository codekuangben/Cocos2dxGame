package modulecommon.net.msg.worldbossCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqInspireWBCmd extends stWorldBossCmd
	{
		
		public function stReqInspireWBCmd() 
		{
			byParam = PARA_REQ_INSPIRE_WBCMD;
		}
		
	}

}
/*
	//请求鼓舞
	const BYTE PARA_REQ_INSPIRE_WBCMD = 10;
	struct stReqInspireWBCmd : public stWorldBossCmd
	{
		stReqInspireWBCmd()
		{
			byParam = PARA_REQ_INSPIRE_WBCMD;
		}
	};
*/