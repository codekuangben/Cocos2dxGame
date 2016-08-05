package modulecommon.ui
{
	/**
	 * 界面ID定义
	 * 0xabbbcccc
	 * 其中，a表示在第几层；bbb表示实例编号；cccc表示类编号
	 * @author zouzhiqiang
	 */
	public final class UIFormID
	{
		public static function Layer(ID:uint):int
		{
			return ID >> LAYER_BIT;
		}
		public static function hasCircleLoadingEffect(ID:uint):Boolean
		{
			return (ID & 1 << CircleLoading_BIT) != 0;
		}
		//
		private static const LAYER_BIT:uint = 28;	//28~31位表示层
		private static const CircleLoading_BIT:uint = 27;// 27位 1-加载时，需要有加载进度动画
		private static const ModuleGame_BIT:uint = 26;// 26位 1-加载时，需要有加载进度动画
		private static const INSTANCE_BIT:uint = 16;
		
		public static const FirstLayer:uint = 0;
		public static const SecondLayer:uint = 1;
		public static const ThirdLayer:uint = 2;
		public static const FourthLayer:uint = 3;
		public static const BattleLayer:uint = 4;
		public static const ProgLoading:uint = 5;
		public static const CGLayer:uint = 6;
		public static const PlaceLayer:uint = 7;		// 占位层，不显示的层，仅仅是统一流程
		public static const MaxLayer:uint = PlaceLayer;
		
		public static const UILogin:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 1;
		public static const UIChat:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 2;
		public static const UiSysBtn:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 3;
		public static const UIRadar:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 4;
		public static const UIHero:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5;
		public static const UIPropmtOne:uint = FirstLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 6;
		public static const UIUprightPrompt:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 7;
		public static const UINpcDisappearAni:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 8;
		public static const UIScreenBtn:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 9;
		public static const UITaskTrace:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 10;
		public static const UIDebug:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 11;
		public static const UICangbaoku:uint = FirstLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 12;
		public static const UIFallObjectPicupAni:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 13;
		public static const UIArenaInfomation:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 14;
		public static const UITaskPrompt:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 15;
		//public static const UIInfoTip:uint = FirstLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 16; // 各种小提示
		public static const UIGZJJChallenge:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 17;	// 官职竞技玩家头顶挑战按钮
		public static const UIDaZuo:uint = FirstLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 18;	// 打坐修练小界面
		
		//---------------------------------------
		
		public static const UIBackPack:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 2;
		
		public static const UITask:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 4;
		public static const UINetWorkDropped:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 5;
		public static const UIFuben:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 6;
		
		
		// 测试时期，日志窗口
		public static const UILog:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 8;
		public static const UIZhenfa:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 9;		
		
		
		public static const UITurnCard:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 13;	// 翻牌
		public static const UICopiesAwards:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 14;		// 副本奖励，显示的时候一定要调用这个
		public static const UIXingMai:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 15;	//星脉
		
		public static const UISelectEmbranchment:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 16;
		public static const UIJiuGuan:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 17;
		public static const UIRecruit:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 18;
		public static const UIWorldMap:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 19;
		public static const UIGamble:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 20;
		
		public static const UIEquipSys:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 21;
		public static const UIRecruitCard:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 22;	//酒馆界面中，武将招募卡牌界面
		//public static const UICangbaoku:uint = SecondLayer << LAYER_BIT | 0 << INSTANCE_BIT | 23;
		
		public static const UIBarrierZhenfa:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 25;
		
		public static const UICopyCountDown:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 26;	// 副本倒计时
		public static const UIEliteBarrier:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 27;	//战役挑战，关卡选择界面
		public static const UIMail:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 28;
		public static const UIMailContent:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 29;
		public static const UIMailWrite:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 30;
		
		public static const UIArenaWeekReward:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 31;
		public static const UIArenaSalary:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 32;
		public static const UIArenaLadder:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 33;
		public static const UIArenaStarter:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 34;
		public static const UIArenaBetialRank:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 35;
		
		public static const UICreateNameHero:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 36;
		public static const UIHeroSelect:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 37;	// 角色选择
		
		public static const UIGuoguanzhanjiang:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 38;	//过关斩将
		public static const UIGgzjRank:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 39;	//过关斩将
		public static const UIGgzjWuList:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 40;	//过关斩将
		public static const UIGgzjDie:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 41;	//过关斩将
		
		public static const UIXuanShangRenWu:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 42;		//悬赏任务
		public static const UIChaifenDlg:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 44;		//道具拆分界面
		public static const UIFubenSaoDang:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 46;		//副本扫荡(玩家输入扫荡信息界面)
		public static const UISaoDangIngInfo:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 47;		//扫荡(正在扫荡过程中显示扫荡信息)
		public static const UISaoDangReward:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 48;		//扫荡领奖界面
		
		public static const UIScreenSlide:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 49;		// 屏幕滚动
		public static const UIWuJiangZhuanShengAni:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 50;	//武将转生特效
		public static const UISnatchTreasure:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 51;	//抢夺宝物界面
		public static const UIRecruitPurpleWu:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 52;	//紫武将合成界面
		public static const UIFlyAni:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 53;			// 登陆场经飞行特效层
		public static const UIZhanliUpgrade:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 54;			//战力提升界面
		public static const UIZhanliUpgradeWuList:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 55;		//战力提升武将招募界面
		public static const UIZhanYiResult:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 56;		//战役挑战结果界面
		
		
		// 礼包,加载统一加载 UIGiftPack 
		public static const UIGPOnCntDw:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 57;		//在线倒计时礼包
		public static const UIGPLvl:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 58;		//等级礼包
		public static const UIInput:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT | 0 << INSTANCE_BIT | 59;		//vip充值界面
		public static const UIGPHuodong:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 60;	//活动礼包
		public static const UIFirstRecharge:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 61;	//首充大礼界面
		public static const UIAddFriendFight:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 62;	//好友夺宝//带好友打怪怪
		public static const UIVipPrivilege:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 63;	//vip特权
		public static const UIBuyLingpai:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 64;	//购买令牌界面
		public static const UIBestCopyPk:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 65;	//副本最佳闯关界面
		public static const UIFastSwapEquips:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 66;	//一键换装备
		public static const UIWuZhuansheng:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 67;	//武将转生
		public static const UIGodlyWeapon:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 68;	//神兵
		public static const UIGgzjExpReward:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 69;	//过关斩将经验奖励
		
		public static const UIOtherPlayer:uint = SecondLayer << LAYER_BIT  | 1 << CircleLoading_BIT | 0 << INSTANCE_BIT | 70;		//
		//public static const UIHeroSelectNew:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 71;	// 角色选择新界面
		public static const UIWatchPlayer:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 72;
		public static const UIWatchSelfAttr:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 73;
		
		public static const UIAniGetGiftObj:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 74;
		public static const UIMapName:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 75;	// 地图的名字
		public static const UIMCloud:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 76; // 主场景场景云效果
		public static const UIInfoTip:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 77; // 各种小提示
		public static const UIIngotBefall:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 78;	//财神降临
		public static const UIGWSkill:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 79;	//神兵技能—号令天下
		
		public static const UIFndReq:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 80;	// 好友请求界面
		public static const UIFndLst:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 81;	// 好友列表
		public static const UIFndAdd:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 82;	// 好友添加
		public static const UIFndZhuFu:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 83;	// 好友祝福
		public static const UIWuXiaye:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 85;	// 下野武将界面
		public static const UIFndMenu:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 86;	// 好友菜单
		
		public static const UICorpsCreate:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 87;	// 军团创建
		public static const UICorpsLst:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 88;	// 军团列表
		public static const UICorpsInfo:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 89;	// 军团信息
		public static const UICorpsDonate:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 91;	// 军团捐献
		public static const UICorpsKejiYanjiu:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 92;	//军团科技研究
		public static const UICorpsKejiLearn:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 93;	//军团科技研究
		public static const UICorpsMgr:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 94;	//军团科技研究
		public static const UICorpsTaskPublish:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 95;
		public static const UITaskJiequ:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 96;
		
		
		public static const UIFndFlyAni:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 97;	// 好友动画
		public static const UIChangePosition:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 98;	// 好友动画
		public static const UICorpsCity:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 99;	// 城市争霸大地图
		public static const UICorpsBrowsePower:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 100;	//军团权力一览
		public static const UICorpsBoxAssign:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 101;	//军团宝箱分配
		public static const UICorpsModifyAnnouncement:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 102;	//军团宝箱分配	
		public static const UIFriendsForBaowu:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 104;
		public static const UIShoucangGame:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 105;
		public static const UICorpsLottery:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 106;		//军团抽奖
		public static const UISanguoZhangchang:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 107;		
		public static const UISangguoZhanchang_Rank:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 108;
		public static const UISanguoZhanchangRelive:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 109;
		public static const UIZhanxing:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 110;		
		public static const UIYizhelibao:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 111;		
		public static const UIWorldBossReborn:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 112;		//(世界boss)复活等待
		public static const UIWorldBossRank:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 113;		//(世界boss)排名
		public static const UIWorldBossHpInfo:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 114;		//(世界boss)血量信息
		public static const UIWuxueExchange:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 115;	//武学兑换
		public static const UIHuntExchange:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 116;	//武学兑换
		public static const UICorpsTreasureEnter:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 117;//军团夺宝进入界面
		
		public static const UIMarket:uint = SecondLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 600;
		
		public static const UIGiftWatch:uint = SecondLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 602;
		public static const UISanguoZhangchangEnter:uint = SecondLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 603;
		public static const UICorpsMarket:uint = SecondLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 604;
		public static const UIOpenNewFeature:uint = SecondLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 605;	//开启新功能
		public static const UITongQueTai:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 606;		//铜雀台
		public static const UITongQueWuHui:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 607;		//铜雀舞会
		public static const UITreasureHunt:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 608;		//寻宝
		public static const UIMarketBuy_Gold:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 609;		//元宝商城购买
		public static const UIMarketBuy_Rongyu:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 610;		//荣誉商城购买
		public static const UIMarketBuy_Corps:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 611;		//军团商城购买
		public static const UIQAsys:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 612;		//答题系统
		public static const UIMarketBuy_Quick:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 613;		//答题系统
		public static const UIHeroRally:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 614;		//英雄会
		public static const UIGmWatch:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 615;		//gm查看界面
		//右下角的提示信息界面,预留100个ID范围，即100-199之间的ID预留给提示信息界面
		public static const UIHintMgr:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 900;						               
		public static const UIDynamicBegin:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT | 0 << INSTANCE_BIT | 1000; //动态ID开始
		public static const UIDynamicEnd:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 2000; // 动态ID结束
		
		// 私人聊天使用
		public static const UIPsnChatBegin:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT | 0 << INSTANCE_BIT | 2001; // 私人聊天开始
		public static const UIPsnChatEnd:uint = SecondLayer << LAYER_BIT | 1 << CircleLoading_BIT | 0 << INSTANCE_BIT | 3000; // 私人聊天结束
		
		public static const UICorpsCityInfo:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5000;	// 城市争夺战信息
		public static const UICorpsCityGround:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5001;	// 城市争夺战战场
		public static const UICorpsMsg:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5002;	// 军团城市争夺战信息
		public static const UICorpsAttLst:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5003;	// 军团城市争夺战攻击列表
		public static const UIBNotify:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5004;	// 战报
		
		public static const UITeamFBSel:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5005;	// 组队副本选择
		public static const UITeamFBZX:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5006;	// 组队阵型
		public static const UITeamFBMemInfo:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5007;	// 组队成员信息
		public static const UITeamFBMger:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5008;	// 组队成员管理
		public static const UITeamFBInvite:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5009;	// 组队邀请
		public static const UITeamFBReward:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5010;	// 组队领奖结算
		public static const UICorpsCitySign:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5011;	// 军团城市登陆
		public static const UICorpsCityGroundNew:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5012;	// 军团城市
		public static const UICorpsCityInfoNew:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5013;	// 军团信息
		public static const UIPerson_Rank:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5014;		// 个人排行榜
		
		public static const UIMounts:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5015;		// 坐骑
		public static const UIShouHun:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5016;		// 兽魂
		
		public static const UITeamFBHall:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5017;	// 组队大厅
		public static const UITeamFBCGRank:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5018;	// 组队闯关排行榜
		
		public static const UIBenefitHall:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5019;	// 福利大厅
		public static const UIRanklist:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5020;	// 排行榜
		public static const UICityChangeTips:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5021;	// 军团丢失城市或者获得城市
		public static const UIGiveup:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5022;	// 藏宝库投降界面
		public static const UIBlack:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5023;	// 过关斩将改变地图名黑屏处理
		public static const UIDaoJiShiWuJiang:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5024;	// 倒计时武将
		public static const UIChargeRank:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5025;	// 充值排行榜
		public static const UISysConfig:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5026;	// 系统设置
		public static const UIShouHunOtherPlayer:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5027;		// 其他人兽魂
		public static const UIOpenBox:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5028;		// 藏宝库

		public static const UIBg:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5029;		// 跑商
		public static const UIGoods:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5030;		// 跑商
		public static const UIInfo:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5031;		// 跑商
		public static const UIStart:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5032;		// 跑商
		public static const UITitle:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5033;		// 跑商
		public static const UIClose:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5034;		// 跑商
		public static const UIMysteryShop:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5035;		// 神秘商店
		public static const UIRechatge:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5036;	// 充值返利
		public static const UILQWJ:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5037;	// 领取武将新界面
		public static const UIVipTiYan:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5038;	// VIP 体验
		public static const UIGmShouHunOtherPlayer:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5039;		// gm其他人兽魂
		public static const UIBossMoney:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5039;		// 组队 boss 地图显示金钱
		public static const UIDTRechatge:uint = SecondLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5040;	// 定时充值返利
		//---------------------------		
		public static const UINpcTalk:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 1;		
		public static const UIMenu:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 2;
		
		
		public static const UINewhandPrompt:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 4;
		public static const UINewHand:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 5;
		public static const UIFocus:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 6;
		public static const UIFocusUse:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 7;
		public static const UIZhanliAddAni:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 8;
		public static const UIHintAddObjectAni:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 9;	//战役挑战结果界面
		public static const UIEdit:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 10;
		//public static const UIGPRandom:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 11;			//随机礼包
		public static const UIAnimationGet:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 12;
		public static const UIPlotTips:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 13;	//剧情提示
		public static const UICollectProgress:uint = ThirdLayer << LAYER_BIT   | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 14;
		public static const UIZhanliAdvance_ValueAni:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 15;
		public static const UIAniRewarded:uint = ThirdLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 16;
		public static const UIGPRandomNew:uint = ThirdLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 17;
		
		//---------------------------
		public static const UITip:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 1;
		public static const UIBackBgWordAni:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 2;
		
		public static const UIJiHuoWuJiangAni:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 4;		//激活武将动画
		public static const UIPlayAni:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5;
		public static const UITipInChat:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 6;
		public static const UIGmInfoShow:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 1 << ModuleGame_BIT | 0 << INSTANCE_BIT | 7;
		public static const UIMenuEx:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 8;
		public static const UIExpression:uint = FourthLayer << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 9;
		public static const UIGmPlayerAttributes:uint = FourthLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 10;	
		public static const UIAnnouncement:uint = FourthLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 11;
		public static const UIBackBgImageAni:uint = FourthLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 12;
		
		//----------------------------------------------
		public static const UIFightResult:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 1;
		public static const UIFightBuff:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 2;
		// 从 29 开始使用， buff 使用了 18 个
		public static const UIBattleHead:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 50;
		public static const UIBattleTip:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 51;
		public static const UIBattleSceneShadow:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 52;
		// 测试时期，日志窗口
		public static const UIBattleLog:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 53;
		public static const UIReplay:uint = BattleLayer << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 54; // 战斗中立即退出和回放
		public static const UIFTurnCard:uint = BattleLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 55; // 这个是在战斗场景中显示的翻拍奖励,
		public static const UICloud:uint = BattleLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 56; // 战斗场景云效果
		
		public static const UIJNHalfImg:uint = BattleLayer << LAYER_BIT | 1 << CircleLoading_BIT| 0 << INSTANCE_BIT | 57; // 锦囊半身像

		// 加载进度条层
		// 加载进度条
		public static const UIProgLoading:uint = ProgLoading << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 0;
		// 资源加载的时候显示一个环形圈
		public static const UICircleLoading:uint = ProgLoading << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 1;
		public static const UISceneTran:uint = ProgLoading << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 2;
		public static const UIMapSwitchEffect:uint = ProgLoading << LAYER_BIT | 0 << CircleLoading_BIT| 0 << INSTANCE_BIT | 3;
		public static const UIDebugLog:uint = ProgLoading << LAYER_BIT | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 4;
		
		// 占位层，不显示的层，仅仅是统一流程
		public static const UIGiftPack:uint = PlaceLayer << LAYER_BIT | 0 << INSTANCE_BIT | 0;
		public static const UIChatSystem:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 1;	// 弹出窗口聊天系统
		public static const UICorpsCitySys:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 2;	// 军团城市争夺战
		public static const UITeamFBSys:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 3;	// 组队副本系统
		public static const UIWorldBossSys:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 4;	// 世界boss
		public static const UIMountsSys:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 5;	// 坐骑系统
		public static const UIPaoShangSys:uint = PlaceLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 6;		// 跑商
		
		public static const UICGIntro:uint = CGLayer << LAYER_BIT  | 0 << CircleLoading_BIT | 0 << INSTANCE_BIT | 1;	// cg 场景动画
	}
}