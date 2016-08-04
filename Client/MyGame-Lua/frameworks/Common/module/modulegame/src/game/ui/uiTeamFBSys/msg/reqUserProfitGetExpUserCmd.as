package game.ui.uiTeamFBSys.msg
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqUserProfitGetExpUserCmd extends stCopyUserCmd
	{
		public function reqUserProfitGetExpUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_USE_PROFIT_GET_EXP_REWARD;
		}
	}
}

//请求使用收益获取通关经验奖励 c->s 
//const BYTE REQ_USE_PROFIT_GET_EXP_REWARD = 59; 
//struct reqUserProfitGetExpUserCmd : public stCopyUserCmd
//{   
//	reqUserProfitGetExpUserCmd()
//	{   
//		byParam = REQ_USE_PROFIT_GET_EXP_REWARD;
//	}   
//};