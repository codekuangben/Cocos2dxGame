package game.ui.uiTeamFBSys.msg 
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqTeamAssistInfoUserCmd extends stCopyUserCmd
	{
		public function stReqTeamAssistInfoUserCmd() 
		{
			super();
			byParam = stCopyUserCmd.PARA_REQ_TEAM_ASSIST_INFO_USERCMD;
		}
	}
}

//请求组队助人礼信息
//const BYTE PARA_REQ_TEAM_ASSIST_INFO_USERCMD = 65; 
//struct stReqTeamAssistInfoUserCmd : public stCopyUserCmd
//{   
	//stReqTeamAssistInfoUserCmd()
	//{   
		//byParam = PARA_REQ_TEAM_ASSIST_INFO_USERCMD;
	//}   
//};