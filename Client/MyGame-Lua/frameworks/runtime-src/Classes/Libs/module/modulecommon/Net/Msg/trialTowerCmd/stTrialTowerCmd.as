package modulecommon.net.msg.trialTowerCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author 
	 * //过关斩将表(试练塔)
	 */
	public class stTrialTowerCmd extends stNullUserCmd 
	{
		public static const REFRESH_TRIAL_TOWER_DATA_PARA:uint = 1;		//向服务器请求信息stRetXMInfoCmd
		public static const REQ_TRIAL_TOWER_UIINFO_PARA:uint = 2;
		public static const RET_TRIAL_TOWER_UIINFO_PARA:uint = 3;
		public static const REQ_START_CHALLENGE_PARA:uint = 4;
		public static const REQ_TRY_AGAIN_PARA:uint = 5;		//向服务器请求信息stRetXMInfoCmd
		public static const REQ_START_AGAIN_PARA:uint = 6;
		public static const REQ_GIVEUP_CHALLENE_PARA:uint = 7;
		public static const NOTIFY_USER_STATE_PARA:uint = 8;
		public static const NOTIFY_HERO_LEFT_HP_PER_PARA:uint = 9;
		public static const REQ_TRIAL_TOWER_SORT_PARA:uint = 10;
		public static const RET_TRIAL_TOWER_SORT_PARA:uint = 11;
		public static const SEND_ONLINE_DATA_PARA:uint = 12;
		public function stTrialTowerCmd() 
		{
			byCmd = TRIALTOWER_USERCMD;
		}
		
	}

}