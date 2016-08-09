package modulecommon.net.msg.trialTowerCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqGiveUpChallengeCmd extends stTrialTowerCmd 
	{
		
		public function stReqGiveUpChallengeCmd() 
		{
			byParam = REQ_GIVEUP_CHALLENE_PARA;
		}
		
	}

}

//放弃
	/*const BYTE REQ_GIVEUP_CHALLENE_PARA = 7;
	struct stReqGiveUpChallengeCmd : public stTrialTowerCmd
	{
		stReqGiveUpChallengeCmd()
		{
			byParam = REQ_GIVEUP_CHALLENE_PARA;
		}
	};*/