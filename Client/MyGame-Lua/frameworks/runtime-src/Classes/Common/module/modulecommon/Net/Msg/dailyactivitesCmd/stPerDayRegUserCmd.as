package modulecommon.net.msg.dailyactivitesCmd 
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stPerDayRegUserCmd extends stSceneUserCmd
	{
		
		public function stPerDayRegUserCmd() 
		{
			byParam = SceneUserParam.PARA_PER_DAY_REG_USERCMD;
		}
		
	}

}
/*
	//签到 c->s
	const BYTE PARA_PER_DAY_REG_USERCMD = 49;
	struct stPerDayRegUserCmd : public stSceneUserCmd
	{
		stPerDayRegUserCmd()
		{
			byParam = PARA_PER_DAY_REG_USERCMD;
		}
	};
*/