package modulecommon.net.msg.sceneUserCmd
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SceneUserParam 
	{
		//public static const SCENE_USERCMD:uint = 3;
		
		public static const RETURN_USER_REG_SCENE_PARA:uint = 1;	//stReturnUserRegSceneCmd
		public static const MAP_DATA_USERCMD_PARA:uint = 2;		//stMapDataUserCmd
		public static const MAIN_USER_DATA_USERCMD_PARA:uint = 3;		//stMainUserDataUserCmd
		public static const USERMOVE_MOVE_USERCMD_PARA:uint = 4;
		
		public static const ADD_USER_AND_POS_MAPSCREEN_USERCMD_PARA:uint = 5;
		public static const SEND_NINE_SCREEN_USERDATA_USERCMD_PARA:uint = 6;
		public static const SEND_NINE_SCREEN_NPCDATA_USERCMD_PARA:uint = 7;
		public static const REMOVE_ENTRY_MAPSCREEN_USERCMD_PARA:uint = 8;
		public static const BATCHREMOVENPC_MAPSCREEN_USERCMD_PARA:uint = 9;
		public static const BATCHREMOVEUSER_MAPSCREEN_USERCMD_PARA:uint = 10;
		public static const QUEST_DIALOG_USERCMD_PARAMETER:uint = 12;		
		public static const KILL_NPC_USERCMD_PARAMETER:uint = 13;
		public static const VISIT_NPC_USERCMD_PARA:uint = 14;
		public static const USER_GOTO_USERCMD_PARA:uint = 15;
		public static const ADJUST_USER_PROP_USERCMD_PARA:uint = 16;
		public static const USER_DATA_USERCMD_PARA:uint = 17;
		public static const NPCMOVE_MOVE_USERCMD_PARA:uint = 18;
		
		public static const AUTO_MOVE_USERCMD_PARA:uint = 19;
		public static const GAME_TOKEN_USERCMD_PARA:uint = 20;
		
		public static const PARA_ATTACK_USERCMD:uint = 2;
		public static const ADDMAPNPC_MAPSCREEN_USERCMD_PARA:uint = 11;
		public static const REQ_GOTO_MAP_USERCMD_PARA:uint = 21;
		public static const ADD_FAKE_USER_AND_POS_MAPSCREEN_USERCMD_PARA:uint = 22;
		public static const SEND_NINE_SCREEN_FAKE_USERDATA_USERCMD_PARA:uint = 23;
		public static const REQ_SET_COMMONSET_USERCMD_PARA:uint = 24;
		public static const RET_COMMONSET_USERCMD_PARA:uint = 25;
		
		public static const REQ_MODIFYNAME_USERCMD_PARA:uint = 26;			// 请求改名字
		public static const RET_MODIFYNAME_USERCMD_PARA:uint = 27;			// 返回一个随机名字
		public static const REQ_VERIFY_USE_NAME_USERCMD_PARA:uint = 28;		//c->s 确认使用XX名字
		public static const RET_VERIFY_USE_NAME_USERCMD_PARA:uint = 29;		//s->c 确认使用XX名字
		public static const YET_OPEN_NEW_FUNCTION_USERCMD_PARA:uint = 30;	//s-c 新功能开启，上线发送已开启的功能
		public static const OPEN_ONE_FUNCTION_USERCMD_PARA:uint = 31;		//s->c 开启一项新功能
		public static const STOP_MOVE_USERCMD_PARA:uint = 32;
		public static const REQ_OTER_CLIENT_DEBUG_INFO_PARA:uint = 33;
		public static const RET_OTHER_CLIENT_DEBUG_INFO_PARA:uint = 34;
		public static const PK_SRC_PRELOAD_USERCMD:uint = 37;
		public static const UPDATE_USER_VIP_SCORE_USERCMD_PARA:uint = 38;	//vip分值
		public static const CHANGE_MAP_USERDATA_USERCMD_PARA:uint = 39;
		public static const TEST_VIP_RECHARGE_USERCMD_PARA:uint = 40;	//vip充值测试消息
		public static const REQ_VIEW_USERCMD_PARA:uint = 41;			//请求观察某人
		public static const RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA:uint = 42;	//发送被观察者人物主信息
		public static const PARA_SET_USERSTATE_USERCMD:uint = 44;	
		public static const PARA_PER_DAY_VALUE_USERCMD:uint = 45;		//通知每日活跃值
		public static const PARA_OPEN_PER_DAY_TODO_USERCMD:uint = 46;	//请求打开打卡界面
		public static const PARA_PER_DAY_TO_DO_USERCMD:uint = 47;
		public static const PARA_GET_PER_DAY_ACTIVE_USERCMD:uint = 48;	//领取每日获取宝箱内容
		public static const PARA_PER_DAY_REG_USERCMD:uint = 49;			//签到
		public static const PARA_NOTIFY_FIGHTNUM_LIMIT_USERCMD:uint = 50;	//通知上阵人数上限
		public static const UPDATE_USER_CORPSNAME_USERCMD:uint = 51;	//通知上阵人数上限
		
		public static const SHOW_ACTIVITY_ICON_USERCMD:uint = 52;
		public static const MINOR_USER_TIP_USERCMD:uint = 53;		//未成年人提示框
		public static const SYN_ONLINE_FIN_DATA_USERCMD:uint = 54;
		public static const UPDATE_MAIN_TEMPID_USERCMD_PARA:uint = 56;
		public static const UPDATE_USER_MOVE_SPEED_USERCMD_PARA:uint = 57;
		public static const PARA_USER_BUFFER_LIST_USERCMD:uint = 58;	//玩家buff列表
		public static const PARA_ADD_BUFFER_TO_USER_USERCMD:uint = 59;	//人物身上添加buffer
		public static const PARA_REMOVE_ONE_BUFFER_USERCMD:uint = 60;	//删除人物身上buffer
		
		public static const PARA_TREASURE_HUNTING_UIINFO_USERCMD:uint = 61;	//上线寻宝数据
		public static const PARA_REFRESH_HUNTING_BIGPRIZE_USERCMD:uint = 62;	//刷新大奖纪录
		public static const PARA_REFRESH_HUNTING_PERSONAL_PRIZE_USERCMD:uint = 63;	//刷新个人中奖纪录
		public static const PARA_START_HUNTING_USERCMD:uint = 64;	//请求寻宝
		public static const PARA_HUNTING_RESULT_USERCMD:uint = 65;	//寻宝结果
		
		public static const PARA_GODLY_WEAPON_SYS_INFO_USERCMD:uint = 66;	//上线神兵数据
		public static const PARA_ADD_GODLY_WEAPON_USERCMD:uint = 67;		//获得神兵
		public static const PARA_WEAR_GODLY_WEAPON_USERCMD:uint = 68;		//佩戴神兵
		public static const UPDATE_TRIAL_TOWER_MAP_NAME_USERCMD:uint = 69;
		public static const PARA_NOTIFY_ANSWER_QUESTION_QUESTNPC_INFO_USERCMD:uint = 70;//答题任务发布npc信息
		public static const PARA_RET_QUESTION_INFO_USERCMD:uint = 71;//答题信息
		public static const PARA_ANSWER_QUESTION_USERCMD:uint = 72;//答题
		
		public static const PARA_USER_ACT_RELATIONS_USERCMD:uint = 73;//主角激活关系
		public static const PARA_ACTIVE_USER_ACT_RELATION_USERCMD:uint = 74;//请求激活关系
		public static const PARA_NOTIFY_TREASURE_HUNTING_SCORE_USERCMD:uint = 75;//通知寻宝积分
		public static const PARA_THSCORE_EXCHANGE_OBJ_USERCMD:uint = 76;//寻宝积分兑换物品
		public static const GM_RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA:uint = 77;
		public static const PRACTICE_VIP_TIME_USERCMD_PARA:uint = 78;//vip体验
		public static const REQ_PRACTICE_VIP_USERCMD_PARA:uint = 79;//vip体验
		public static const PARA_GODLY_WEAPON_SKILL_TRAIN_USERCMD:uint = 80;//神兵技能培养
		public static const PARA_GODLY_WEAPON_SKILL_TRAIN_RESULT_USERCMD:uint = 81;//神兵技能培养返回
		public static const PARA_VIEW_OTHER_USER_GWSYS_INFO_USERCMD:uint = 82;//被观察者神兵信息
	}
}