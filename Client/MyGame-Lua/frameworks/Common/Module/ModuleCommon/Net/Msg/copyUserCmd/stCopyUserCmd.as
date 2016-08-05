package modulecommon.net.msg.copyUserCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	//import flash.utils.ByteArray;
	//import common.net.endata.EnNet;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stCopyUserCmd extends stNullUserCmd 
	{
		public static const REQ_CREATE_COPY_USERCMD:uint = 1;		//创建副本
		public static const NOTIFY_AVAILABLE_COPY_USERCMD:uint = 2;	//可以进入的副本列表
		public static const SYNC_LEAVE_COPY_USERCMD:uint = 3;		//退出副本
		public static const REQ_AVAILABLE_COPY_USERCMD:uint = 4;	//请求可用副本
		public static const NOTIFY_COPY_OVER_USERCMD:uint = 8;	//请求可用副本
		public static const COPY_CLEARANCE_USERCMD:uint = 5;	// 消息号,副本通关消息，战斗和 UI 界面都要用
		public static const COPY_REWARD_USERCMD:uint = 7;	//翻牌后客户端显示数据
		public static const REQ_MAX_CLEARANCE_ID_USERCMD:uint = 9;		//请求最大通关关卡id
		public static const RET_MAX_CLEARANCE_ID_USERCMD:uint = 10;	//返回最大通关id
		
		public static const RET_CANG_BAO_KU_DATA_USERCMD:uint = 12;	//登陆后，服务器主动发到客户端
		public static const REQ_CREATE_CANG_BAO_KU_COPY_USERCMD:uint = 13;	//创建藏宝窟副本
		public static const UPDATE_REMAINING_COUNT:uint = 14;	////更新剩余探宝次数
		public static const UPDATE_CUR_LAYER:uint = 15;	//更新当前层数
		public static const UPDATE_BOX_LIST:uint = 16;	//更新宝箱列表
		public static const OPEN_CANG_BAO_KU_BOX:uint = 17;	//打开箱子
		public static const RET_CREATE_COPY_USERCMD:uint = 18;	//打开箱子
		
		public static const REQ_CANGBAOKU_GUARD_USERCMD:uint = 19;	// 请求刷新副本守卫
		public static const SYNC_TIME_CLEAR_DATA_USERCMD:uint = 20;	// 藏宝窟清空数据
		public static const st7_CLOCK_USERCMD:uint = 21;	// 藏宝窟清空数据 
		public static const REQ_BOX_TIP_CONTEXT_USERCMD:uint = 22;	// 请求 tips
		public static const RET_BOX_TIP_CONTEXT_USERCMD:uint = 23;	// 返回 tips
		public static const REQ_LEAVE_COPY_USERCMD:uint = 24;	//请求退出副本
		public static const REQ_SAO_DANG_COPY_USERCMD:uint = 25;	//客户端请求扫荡副本
		public static const SYN_SAO_DANG_COPY_USERCMD:uint = 26;	//客户端请求扫荡副本
		public static const CLICK_SAO_DANG_MENU_USERCMD:uint = 27;	//请求扫荡奖励
		public static const RET_SAO_DANG_COPY_REWARD_USERCMD:uint = 28;	//返回扫荡奖励
		public static const GET_SAO_DANG_COPY_REWARD_USERCMD:uint = 29;	//请求领奖
		
		public static const QUICK_FINISH_SAO_DANG_COPY_USERCMD:uint = 30;	//客户端请求立即完成扫荡
		public static const RET_QUICK_FINISH_SAO_DANG_YUAN_BAO_USERCMD:uint = 31;	//返回立即完成所需元宝
		public static const REQ_YUAN_BAO_COOLING_USERCMD:uint = 32;	//元宝加速
		public static const RET_YUAN_BAO_COOLING_TIME_USERCMD:uint = 33;	//冷却时间更新
		public static const SYN_SEND_BOX_OBJS_END_USERCMD:uint = 34;	//冷却时间更新
		public static const PARA_RET_REFRESH_CBK_DATA_USERCMD:uint = 35;	// 藏宝库刷新次数
		public static const PARA_REFRESH_CHECK_POINT_LIST_USERCMD:uint = 36;
		
		public static const PARA_OPEN_MULTI_COPY_UI_USERCMD:uint = 37;
		public static const RET_OPEN_MULTI_COPY_UI_USERCMD:uint = 38;
		public static const PARA_CLICK_MULTI_COPY_UI_USERCMD:uint = 39;
		public static const RET_CLICK_MULTI_COPY_UI_USERCMD:uint = 40;
		public static const REQ_ADD_MULTI_COPY_USERCMD:uint = 41;
		
		public static const REQ_OPEN_INVITE_ADD_MULTI_COPY_UI_USERCMD:uint = 42;
		public static const RET_INVITE_ADD_MULTI_COPY_UI_USERCMD:uint = 42;
		
		public static const REQ_INVITE_OTHER_ADD_MULTI_COPY_USERCMD:uint = 43;
		public static const INVITE_ME_ADD_MULTI_COPY_USERCMD:uint = 44;
		public static const REFUSE_INVITE_ADD_MULTI_COPY_USERCMD:uint = 45;
		public static const REQ_USE_PROFIT_IN_COPY_USERCMD:uint = 46;//请求本副本使用收益
		public static const RET_USE_PROFIT_IN_COPY_USERCMD:uint = 47;//返回请求本副本使用收益
		public static const QUICK_INVITE_OTHER_ADD_MULTI_COPY_USERCMD:uint = 48;//快速邀请加入多人副本 c->s
		
		public static const REQ_OPEN_ASSGIN_HERO_UI_USERCMD:uint = 49;
		public static const RET_OPEN_ASSGIN_HERO_UI_USERCMD:uint = 50;
		
		public static const REQ_CHANGE_USER_POS_USERCMD:uint = 51;
		public static const RET_CHANGE_USER_POS_USERCMD:uint = 52;
		public static const REQ_CHANGE_ASSGIN_HERO_USERCMD:uint = 53;
		public static const RET_CHANGE_ASSGIN_HERO_USERCMD:uint = 54;
		
		public static const NOTIFY_BEST_COPY_PK_REVIEW_USERCMD:uint = 55;
		public static const REQ_BEST_COPY_PK_REVIEW_USERCMD:uint = 56;
		public static const RET_FIGHT_HERO_DATA_USERCMD:uint = 57;
		public static const SYN_COPY_REWARD_EXP_USERCMD:uint = 58;
		
		public static const REQ_USE_PROFIT_GET_EXP_REWARD:uint = 59;
		public static const st0_CLOCK_USERCMD:uint = 60;				//00:00:00点数据重置
		public static const SYN_MULTI_USER_COPY_PROFIG_COUNT_USERCMD:uint = 61;	//组队副本今日剩余次数
		public static const SYN_TEAM_BOSS_TODAY_CENG_USERCMD:uint = 62;
		public static const REQ_TEAM_BOSS_RANK_USERCMD:uint = 63;
		public static const RET_TEAM_BOSS_RANK_USERCMD:uint = 64;
		
		public static const PARA_REQ_TEAM_ASSIST_INFO_USERCMD:uint = 65;
		public static const PARA_RET_TEAM_ASSIST_INFO_USERCMD:uint = 66;
		public static const PARA_GAIN_TEAM_ASSIST_GIFT_USERCMD:uint = 67;
		public static const NOTIFY_TOUXIANG_DATA:uint = 68;
		public static const REQ_TOUXIANG_GIVE_BAOWU:uint = 69;
		public static const REQ_BROAD_DOUBLE_BAOWU:uint = 70;
		
		public function stCopyUserCmd() 
		{
			super();
			byCmd = COPY_USERCMD;
		}		
	}
}