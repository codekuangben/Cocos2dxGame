package modulecommon.net.msg.worldbossCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqEnterWorldBossWBCmd extends stWorldBossCmd
	{
		
		public function stReqEnterWorldBossWBCmd() 
		{
			byParam = PARA_REQ_ENTER_WORLDBOSS_WBCMD;
		}
		
	}

}
/*
	//请求进入世界boss地图
	const BYTE PARA_REQ_ENTER_WORLDBOSS_WBCMD = 3;
	struct stReqEnterWorldBossWBCmd : public stWorldBossCmd
	{
		stReqEnterWorldBossWBCmd()
		{
			byParam = PARA_REQ_ENTER_WORLDBOSS_WBCMD;
		}
	};
*/