package modulecommon.net.msg.trialTowerCmd 
{
	import modulecommon.net.msg.trialTowerCmd.stTrialTowerCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stReqTrialTowerSortCmd extends stTrialTowerCmd 
	{
		
		public function stReqTrialTowerSortCmd() 
		{
			byParam = REQ_TRIAL_TOWER_SORT_PARA;
		}
		
	}

}

///请求排行榜信息
	/*const BYTE REQ_TRIAL_TOWER_SORT_PARA = 10;
	struct stReqTrialTowerSortCmd : public stTrialTowerCmd
	{
		stReqTrialTowerSortCmd()
		{
			byParam = REQ_TRIAL_TOWER_SORT_PARA;
		}
	};*/