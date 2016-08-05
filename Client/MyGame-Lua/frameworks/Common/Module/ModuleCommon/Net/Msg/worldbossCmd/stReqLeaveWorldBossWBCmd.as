package modulecommon.net.msg.worldbossCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqLeaveWorldBossWBCmd extends stWorldBossCmd
	{
		
		public function stReqLeaveWorldBossWBCmd() 
		{
			byParam = PARA_REQ_LEAVE_WORLDBOSS_WBCMD;
		}
		
	}

}
/*
	//请求离开世界boss地图
	const BYTE PARA_REQ_LEAVE_WORLDBOSS_WBCMD = 4;
	struct stReqLeaveWorldBossWBCmd : public stWorldBossCmd
	{
		stReqLeaveWorldBossWBCmd()
		{
			byParam = PARA_REQ_LEAVE_WORLDBOSS_WBCMD;
		}
	};
*/