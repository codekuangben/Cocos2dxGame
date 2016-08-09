package modulecommon.net.msg.trialTowerCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqTrialTowerUIInfo extends stTrialTowerCmd 
	{
		
		public function stReqTrialTowerUIInfo() 
		{
			byParam = REQ_TRIAL_TOWER_UIINFO_PARA;
		}
		
	}

}

///请求试练塔界面信息
	/*const BYTE REQ_TRIAL_TOWER_UIINFO_PARA = 2;
	struct stReqTrialTowerUIInfo : public stTrialTowerCmd
	{
		stReqTrialTowerUIInfo()
		{
			byParam = REQ_TRIAL_TOWER_UIINFO_PARA;
		}
	};*/