package modulecommon.net.msg.sceneHeroCmd
{
	public class reqDetailRobInfoUserCmd extends stSceneHeroCmd
	{
		public function reqDetailRobInfoUserCmd()
		{
			super();
			byParam = stSceneHeroCmd.REQ_DETAIL_ROB_INFO_USERCMD;
		}
	}
}

//请求抢夺战报
//const BYTE REQ_DETAIL_ROB_INFO_USERCMD = 39;
//struct reqDetailRobInfoUserCmd : public stSceneHeroCmd
//{
//	reqDetailRobInfoUserCmd()
//	{
//		byParam = REQ_DETAIL_ROB_INFO_USERCMD;
//	}
//};