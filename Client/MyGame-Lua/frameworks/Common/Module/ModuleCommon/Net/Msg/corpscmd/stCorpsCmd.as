package modulecommon.net.msg.corpscmd
{
	import common.net.msg.basemsg.stNullUserCmd;

	public class stCorpsCmd extends stNullUserCmd
	{
		public static const REQ_CORPS_LIST_USERCMD:uint = 1;
		public static const RET_CORPS_LIST_USERCMD:uint = 2;
		public static const REQ_CREATE_CORPS_USERCMD:uint = 3;
		public static const RET_CREATE_CORPS_USERCMD:uint = 4;
		public static const REQ_JOIN_CORPS_USERCMD:uint = 5;
		public static const RET_JOIN_CORPS_USERCMD:uint = 6;
		public static const NOTIFY_ONE_REQ_JOIN_CORPS_USERCMD:uint = 7;
		public static const RET_ONE_REQ_JOIN_CORPS_USERCMD:uint = 8;
		public static const REQ_DONATE_CORPS_USERCMD:uint = 9;
		public static const NOTIFY_CORPS_NAME_USERCMD:uint = 10;
		public static const QUIT_CORPS_USERCMD:uint = 11;
		public static const EXPEL_CORPS_USERCMD:uint = 12;
		public static const PRIV_CHANGE_USERCMD:uint = 15;
		public static const REQ_CORPS_INFO_USERCMD:uint = 16;
		public static const RET_CORPS_INFO_USERCMD:uint = 17;
		public static const REQ_CORPS_DYNAMIC_INFO_USERCMD:uint = 18;
		public static const RET_CORPS_DYNAMIC_INFO_USERCMD:uint = 19;
		public static const REQ_CORPS_MEMBER_LIST_USERCMD:uint = 20;
		public static const RET_CORPS_MEMBER_LIST_USERCMD:uint = 21;
		public static const REQ_CORPS_BUILDING_USERCMD:uint = 22;
		public static const RET_CORPS_BUILDING_USERCMD:uint = 23;
		public static const RET_DONATE_CORPS_USERCMD:uint = 24;
		public static const NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD:uint = 25;
		public static const REQ_CORPS_YANJIU_KEJI_USERCMD:uint = 26;
		public static const RET_CORPS_KEJI_YAN_JIU_LEVEL_USERCMD:uint = 27;
		public static const REQ_CORPS_INCREASE_KEJI_USERCMD:uint = 28;
		public static const RET_CORPS_INCREASE_KEJI_USERCMD:uint = 29;
		public static const REQ_OEPEN_CORPS_XUEXI_UI_INFO_USERCMD:uint = 30;
		public static const RET_OEPEN_CORPS_XUEXI_UI_INFO_USERCMD:uint = 31;
		public static const REQ_CORPS_XUEXI_KEJI_USERCMD:uint = 32;
		public static const RET_CORPS_XUEXI_KEJI_USERCMD:uint = 33;
		public static const REQ_LEVELUP_CORPS_MAIN_BUILDING_USERCMD:uint = 34;
		public static const RET_LEVELUP_CORPS_MAIN_BUILDING_USERCMD:uint = 35;
		public static const UPDATE_CORPS_WUZI_USERCMD:uint = 36;
		public static const UPDATE_USER_CORPS_CONTRI_USERCMD:uint = 37;
		public static const REQ_CORPS_QUEST_SET_UI_USERCMD:uint = 38;
		public static const RET_CORPS_QUEST_SET_UI_USERCMD:uint = 39;
		public static const REQ_CORPS_ALL_QUEST_INFO_USERCMD:uint = 40;
		public static const RET_CORPS_QUEST_INFO_USERCMD:uint = 41;
		public static const REQ_SET_IMPORT_CORPS_QUEST_USERCMD:uint = 42;
		public static const RET_SET_IMPORT_CORPS_QUEST_USERCMD:uint = 43;
		public static const REQ_OPEN_CORPS_QUEST_UI_USERCMD:uint = 44;
		public static const RET_OPEN_CORPS_QUEST_UI_USERCMD:uint = 45;
		public static const REQ_GET_CORPS_QUEST_USERCMD:uint = 46;
		public static const RET_GET_CORPS_QUEST_USERCMD:uint = 47;
		public static const REQ_SET_ALL_IMPORT_QUEST_USERCMD:uint = 48;
		public static const RET_SET_ALL_IMPORT_QUEST_USERCMD:uint = 49;
		public static const REQ_INVITE_USER_JOIN_CORPS_USERCMD:uint = 50;
		public static const RET_INVITE_USER_JOIN_CORPS_USERCMD:uint = 51;
		public static const RET_AGREE_JOIN_CORPS_USERCMD:uint = 52;
		public static const REQ_EDIT_CORPS_GONGGAO_USERCMD:uint = 53;
		
		public static const UPDATE_CORPS_BOX_NUMBER_USERCMD:uint = 54;	//更新争霸宝箱个数
		public static const REQ_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD:uint = 55;	//请求分配争霸宝箱界面成员信息
		public static const RET_ASSIGN_BOX_UI_CORPS_MEMBER_LIST_USERCMD:uint = 56;	//返回分配宝箱军团成员列表
		public static const REQ_ASSIGN_BOX_LIST_USERCMD:uint = 57;	//请求分配
		public static const NOTIFY_MAX_QUEST_TIMES_USERCMD:uint = 58;	//更新每日可接任务最大次数
		public static const CLICK_INVITE_GONGGAO_CORPS_USERCMD:uint = 60;	//点击军团界面上的邀请按钮
		public static const UPDATE_COOL_DOWN_TIME_CORPS_USERCMD:uint = 61;	//更新军团冷却
		public static const REQ_QUICK_COOL_DOWN_CORPS_USERCMD:uint = 62;	//请求快速冷却
		public static const REQ_BEGIN_CORPS_FIRE_USERCMD:uint = 63;			//军团烤火
		public static const NOTIFY_CORPS_FIRE_POS_USERCMD:uint = 64;		//通知军团烤火坐标
		public static const UPDATE_CORPS_LEVEL_USERCMD:uint = 65;		//军团等级
		
		public static const NOTIFY_CORPS_FIGHT_LAST_TIME_USERCMD:uint = 76;
		public static const NOTIFY_REG_CORPS_FIGHT_USERCMD:uint = 77;
		public static const UPDATE_REG_JOIN_CORPS_FIGHT_STATE_USERCMD:uint = 78;
		public static const REG_JOIN_CORPS_FIGHT_USERCMD:uint = 79;
		
		public static const NOTIFY_CORPS_NPC_ID_USERCMD:uint = 80;
		public static const NOTIFY_BIG_MAP_DATA_USERCMD:uint = 81;
		public static const UPDATE_FIGHT_JI_FEN_DATA_USERCMD:uint = 82;
		public static const UPDATE_CITY_DATA_USERCMD:uint = 83;
		public static const REQ_INTO_CITY_SCENE_USERCMD:uint = 84;
		public static const RET_OPEN_CITY_USERCMD:uint = 85;
		public static const REQ_INTO_CITY_USERCMD:uint = 86;
		public static const REQ_INTO_JUDIAN_USERCMD:uint = 86;
		
		public static const NOTIFY_ZHAN_BAO_USERCMD:uint = 87;
		public static const NOTIFY_BE_ATTACK_USERCMD:uint = 88;
		public static const REQ_ATTACK_REVIEW_LIST_USERCMD:uint = 89;
		public static const RET_ATTACK_REVIEW_LIST_USERCMD:uint = 90;
		public static const REQ_ATTACK_REVIEW_USERCMD:uint = 91;
		public static const REQ_JU_DIAN_ATTACK_REVIEW_USERCMD:uint = 92;
		public static const REQ_LEAVE_JU_DIAN_USERCMD:uint = 93;
		public static const REQ_LEAVE_UI_USERCMD:uint = 94;
		public static const PARA_REQ_CORPS_LOTTERY_USERCMD:uint = 95;	//军团抽奖
		public static const PARA_RET_LOTTERY_RESULT_USERCMD:uint = 96;	//返回军团抽奖结果
		public static const VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD:uint = 97;	//观察玩家军团科技信息
		public static const PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD:uint = 98;	//上线通知抽奖次数
		public static const GM_VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD:uint = 99;
		public static const RET_CORPS_TREASURE_UI_HISTORY_USERCMD:uint = 100;
		public static const REQ_CORPS_TREASURE_UI_HISTORY_USERCMD:uint = 101;
		public static const REQ_INTO_CORPS_TREASURE_USERCMD:uint = 110;
		public static const CORPS_TREASURE_UI_DATA_USERCMD:uint = 111;
		public static const UPDATE_CORPS_TREASURE_JUNLIANG_USERCMD:uint = 112;
		public static const UPDATE_CORPS_TREASURE_RANK_USERCMD:uint = 113;
		public static const UPDATE_CORPS_TREASURE_FREE_RELIVE_USERCMD:uint = 114;
		public static const QUICK_RELIVE_USERCMD:uint = 115;
		public static const SEND_MY_CORPS_NPC_USERCMD:uint = 116;
		public function stCorpsCmd()
		{
			super();
			byCmd = stNullUserCmd.CORPS_USERCMD; //18
		}
		
		public static function initMsg():void
		{
			pushDic(NOTIFY_CORPS_NAME_USERCMD, "notifyCorpsNameUserCmd--stCorpsCmd");
			pushDic(REQ_CORPS_INFO_USERCMD, "reqCorpsInfoUserCmd--stCorpsCmd");
			pushDic(QUIT_CORPS_USERCMD, "reqCorpsInfoUserCmd--quitCorpsUserCmd");
			pushDic(REQ_CORPS_DYNAMIC_INFO_USERCMD, "reqCorpsDynamicInfoUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_DYNAMIC_INFO_USERCMD, "retCorpsDynamicInfoUserCmd--stCorpsCmd");
			pushDic(NOTIFY_CORPS_NAME_USERCMD, "notifyCorpsNameUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_INFO_USERCMD, "retCorpsInfoUserCmd--stCorpsCmd");
			pushDic(REQ_CORPS_MEMBER_LIST_USERCMD, "reqCorpsMemberListUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_MEMBER_LIST_USERCMD, "retCorpsMemberListUserCmd--stCorpsCmd");
			pushDic(REQ_DONATE_CORPS_USERCMD, "reqDonateCorpsUserCmd--stCorpsCmd");
			pushDic(NOTIFY_CORPS_KEJI_PROP_VALUE_USERCMD, "notifyCorpsKejiPropValueUserCmd--stCorpsCmd");
			pushDic(REQ_CORPS_YANJIU_KEJI_USERCMD, "reqCorpsYanjiuKejiUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_KEJI_YAN_JIU_LEVEL_USERCMD, "retCorpsKejiYanJiuLevelUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_INCREASE_KEJI_USERCMD, "retCorpsIncreaseKejiUserCmd--stCorpsCmd");
			pushDic(REQ_CORPS_INCREASE_KEJI_USERCMD, "reqCorpsIncreaseKejiUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_INCREASE_KEJI_USERCMD, "retCorpsIncreaseKejiUserCmd--stCorpsCmd");
			pushDic(REQ_CORPS_BUILDING_USERCMD, "reqCorpsBuildingUserCmd--stCorpsCmd");
			pushDic(RET_CORPS_BUILDING_USERCMD, "retCorpsBuildingUserCmd--stCorpsCmd");
			pushDic(REQ_LEVELUP_CORPS_MAIN_BUILDING_USERCMD, "reqLevelUpCorpsMainBuildingUserCmd--stCorpsCmd");
			pushDic(RET_LEVELUP_CORPS_MAIN_BUILDING_USERCMD, "retLevelUpCorpsMainBuildingUserCmd--stCorpsCmd");
			pushDic(UPDATE_CORPS_WUZI_USERCMD, "updateCorpsWuziUserCmd--stCorpsCmd");
			pushDic(VIEW_USER_CORPS_KEJI_PROP_VALUE_USERCMD, "ViewUserCorpsKejiPropValueUserCmd--stCorpsCmd");
			pushDic(PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD, "stNotifyCorpsLotteryTimesCmd--stCorpsCmd");
		}
		
		public static function pushDic(param:uint, name:String):void
		{
			s_dicMsg[s_toKey(CORPS_USERCMD, param)] = name;
		}
	}
}

//struct stCorpsCmd : public stNullUserCmd
//{
//	stCorpsCmd()
//	{
//		byCmd = CORPS_USERCMD; //18
//	}
//};