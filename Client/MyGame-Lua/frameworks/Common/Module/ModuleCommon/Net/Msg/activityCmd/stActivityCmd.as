package modulecommon.net.msg.activityCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author ...
	 */
	public class stActivityCmd extends stNullUserCmd 
	{
		public static const PARA_OPEN_DUGUAN_INTERFACE_USERCMD:uint = 1;
		public static const RET_DUGUAN_DATA_USERCMD:uint = 2;
		public static const PARA_CLOSE_DUGUAN_INTERFACE_USERCMD:uint = 3;
		public static const REQ_XIAZHU_USERCMD:uint = 4;
		public static const RET_XIAZHU_USERCMD:uint = 5;
		public static const PARA_KAIJIANG_USERCMD:uint = 6;
		public static const FREE_XIAZHU_USERCMD:uint = 7;
		public static const PARA_LIMIT_BIG_SEND_ACTINFO_CMD:uint = 8;
		public static const PARA_NOTIFY_LIMIT_BIG_SEND_ACT_STATE_CMD:uint = 9;
		public static const PARA_REFRESH_LBSA_PROGRESS_CMD:uint = 10;
		public static const PARA_REQ_GET_LBSA_REWARD_CMD:uint = 11;
		public static const PARA_REFRESH_LBSA_ITEM_INFO_CMD:uint = 12;		
		public static const REQ_SEND_ACTIVE_CODE_CMD:uint = 13;	
		public static const NOTIFY_WELFARE_DATA_CMD:uint = 15;	
		public static const BUY_WELFARE_DATA_CMD:uint = 16;	
		public static const GET_BACK_WELFARE_DATA_CMD:uint = 17;	
		public static const PARA_SEVEN_LOGIN_AWARD_INFO_CMD:uint = 19;	
		public static const PARA_GET_SEVEN_LOGIN_REWARD_CMD:uint = 20;	
		public static const PARA_FIX_LEVEL_REWARD_INFO_CMD:uint = 21;	
		public static const PARA_REQ_GET_FIX_LEVEL_REWARD_CMD:uint = 22;	
		public static const PARA_UPDATE_FIX_LEVEL_REWARD_FLAG_CMD:uint = 23;	
		public static const PARA_REQ_RANK_REWARD_RANK_INFO_CMD:uint = 24;	
		public static const PARA_RET_RANK_REWARD_RANK_INFO_CMD:uint = 25;	
		public static const NOTIFY_RECHARGE_BACK_DATA_CMD:uint = 26;	
		public static const UPDATE_RECHARGE_YUANBAO_CMD:uint = 27;	
		public static const GET_RECHARGE_BACK_REWARD_CMD:uint = 28;	
		public static const UPDATE_REWARD_BACK_CMD:uint = 29;
		public static const REQ_REWARD_BACK_CMD:uint = 30;
		public static const DT_NOTIFY_RECHARGE_BACK_DATA_CMD:uint = 31;
		public static const DT_UPDATE_RECHARGE_YUANBAO_CMD:uint = 32;
		public static const DT_GET_RECHARGE_BACK_REWARD_CMD:uint = 33;
		public static const GET_VIP3_PRACTICE_REWARD_CMD:uint = 34;
		
		public function stActivityCmd() 
		{
			byCmd = ACTIVITY_USERCMD;			
		}
		
	}

}

/*
 * struct stActivityCmd : public stNullUserCmd
	{
		stActivityCmd()
		{
			byCmd = ACTIVITY_USERCMD;  // 12
		}
	};
*/