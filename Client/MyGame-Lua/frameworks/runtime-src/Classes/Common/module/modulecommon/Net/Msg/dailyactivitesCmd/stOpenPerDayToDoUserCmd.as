package modulecommon.net.msg.dailyactivitesCmd 
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stOpenPerDayToDoUserCmd extends stSceneUserCmd
	{
		
		public function stOpenPerDayToDoUserCmd() 
		{
			byParam = SceneUserParam.PARA_OPEN_PER_DAY_TODO_USERCMD;
		}
		
	}

}
/*
	//请求打开打卡界面
	const BYTE PARA_OPEN_PER_DAY_TODO_USERCMD = 46;
	struct stOpenPerDayToDoUserCmd : public stSceneUserCmd
	{
		stOpenPerDayToDoUserCmd()
		{
			byParam = PARA_OPEN_PER_DAY_TODO_USERCMD;
		}
	};
*/