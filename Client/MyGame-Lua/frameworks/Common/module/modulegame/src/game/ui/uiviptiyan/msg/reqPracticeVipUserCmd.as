package game.ui.uiviptiyan.msg
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqPracticeVipUserCmd extends stSceneUserCmd
	{
		public function reqPracticeVipUserCmd() 
		{
			super();
			byParam = SceneUserParam.REQ_PRACTICE_VIP_USERCMD_PARA;
		}
	}
}

//请求体验vip c->s
//const BYTE REQ_PRACTICE_VIP_USERCMD_PARA = 79;
//struct reqPracticeVipUserCmd : public stSceneUserCmd
//{
	//reqPracticeVipUserCmd()
	//{
		//byParam = REQ_PRACTICE_VIP_USERCMD_PARA;
	//}
//};