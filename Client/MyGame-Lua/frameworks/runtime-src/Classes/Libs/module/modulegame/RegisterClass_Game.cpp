package game 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.net.msg.copyUserCmd.reqTeamBossRankUserCmd;
	import modulecommon.net.msg.fight.stScenePkCmd;
	import modulecommon.net.msg.propertyUserCmd.stBatchMoveObjActionUserCmd;
	import modulecommon.net.msg.rankcmd.st7DayRechargeRankListCmd;
	import modulecommon.net.msg.sceneUserCmd.stActiveUserActRelationCmd;
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerSortCmd;

	
	import modulecommon.uiinterface.componentinterface.IPeopleRankPage;
	import modulecommon.uiinterface.IUIAniRewarded;
	import modulecommon.uiinterface.IUIArenaSalary;
	import modulecommon.uiinterface.IUIGWSkill;
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.appcontrol.BubbleWordSprite;
	import modulecommon.appcontrol.CoolDownControl;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.appcontrol.DigitComponentWidthSign;
	import modulecommon.appcontrol.Icon_ValueCtrol;
	import modulecommon.appcontrol.MoneyPanel;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.appcontrol.Name_ValueCtrol;
	import modulecommon.appcontrol.PanelCombine1;
	import modulecommon.appcontrol.TipBase;
	import modulecommon.appcontrol.WuIcon;
	import modulecommon.appcontrol.tip.TipEquipBase;
	import modulecommon.appcontrol.tip.TipNotEquipObjBase;
	import modulecommon.commonfuntion.delayloader.DelayLoaderMap;
	import modulecommon.fun.aniObjectMgr.AniObjectMgr;
	import modulecommon.game.IMFight;

	import modulecommon.net.MessageBuffer;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	import modulecommon.net.msg.chatUserCmd.stChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stNpcAiChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stWORDPromptUserCmd;
	import modulecommon.net.msg.copyUserCmd.notifyBestCopyPkReviewCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.reqBestCopyPkReviewCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.reqSaoDangCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.retQuickFinishSaoDangYuanBaoUserCmd;
	import modulecommon.net.msg.copyUserCmd.retYuanBaoCoolingTimeUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqAvailableCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqLeaveCopyUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqMaxClearanceIdUserCmd;
	import modulecommon.net.msg.copyUserCmd.stReqYuanBaoCoolingUserCmd;
	import modulecommon.net.msg.copyUserCmd.stRetMaxClearanceIdUserCmd;
	import modulecommon.net.msg.copyUserCmd.synSaoDangCopyUserCmd;
	import modulecommon.net.msg.corpscmd.reqAssignBoxUiCorpsMemberListUserCmd;
	import modulecommon.net.msg.corpscmd.reqBeginCorpsFireUserCmd;
	import modulecommon.net.msg.corpscmd.reqJoinCorpsUserCmd;
	import modulecommon.net.msg.corpscmd.reqQuickCoolDownCorpsUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stGetPerDayActiveUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stOpenPerDayToDoUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stPerDayRegUserCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stEliteBarrierCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stRetCurBarrierCmd;
	import modulecommon.net.msg.equip.stRemakeEquipCmd;
	import modulecommon.net.msg.fight.stAttackVictoryInfoUserCmd;
	import modulecommon.net.msg.fndcmd.stHelpFriendIdFriendCmd;
	import modulecommon.net.msg.giftCmd.stFirstChargeBoxInfoCmd;
	import modulecommon.net.msg.giftCmd.stFirstChargeBoxStateCmd;
	import modulecommon.net.msg.giftCmd.stNotifyActLiBaoStateCmd;
	import modulecommon.net.msg.giftCmd.stReqActLiBaoContentCmd;
	import modulecommon.net.msg.godlyweaponCmd.stWearGodlyWeaponCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiCmd;
	
	import modulecommon.net.msg.mailCmd.stMailCmd;
	import modulecommon.net.msg.mailCmd.stReqMailListCmd;
	import modulecommon.net.msg.propertyUserCmd.stBuyEquipToHeroCmd;
	import modulecommon.net.msg.propertyUserCmd.stPickUpObjTypeNumberPropertyUserCmd;
	import modulecommon.net.msg.propertyUserCmd.stReqFreeLingPaiInfoCmd;
	import modulecommon.net.msg.propertyUserCmd.stRetFreeLingPaiInfoCmd;
	import modulecommon.net.msg.propertyUserCmd.stUseObjectPropertyUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.stReqRebirthCmd;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroXiaYeCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	import modulecommon.net.msg.sceneUserCmd.stAttackUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stGameTokenUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stMainUserDataUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stNpcMoveUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stQuestDialogUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stReqModifyNameUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stReqOtherClientDebugInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetOtherClientDebugInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetVerifyUseNameUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stSetUserStateCmd;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData2;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.net.msg.shoppingCmd.stReqViewMarketGiftBoxCmd;
	import modulecommon.net.msg.shoppingCmd.stShoppingCmd;
	import modulecommon.net.msg.stResRobCmd.stResRobCmd;
	
	import modulecommon.net.msg.trialTowerCmd.stNotifyUserStateCmd;
	import modulecommon.net.msg.trialTowerCmd.stRefreshTrialTowerDataCmd;
	import modulecommon.net.msg.trialTowerCmd.stReqGiveUpChallengeCmd;
	import modulecommon.net.msg.trialTowerCmd.stSendOnlineDataCmd;
	import modulecommon.net.msg.trialTowerCmd.stTrialTowerCmd;
	import modulecommon.net.msg.xingMaiCmd.stChangeUserSkillXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMAttrXMCmd;
	import modulecommon.net.msg.xingMaiCmd.stLevelUpXMSkillXMCmd;
	import modulecommon.net.msg.zhanXingCmd.stSwapShenBingCmd;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.jiuguan.ItemWu;
	import modulecommon.scene.prop.job.Soldier;
	import modulecommon.scene.prop.object.GemIcon;
	import modulecommon.scene.prop.relation.KejiItemInfo;
	import modulecommon.scene.prop.relation.corps.CorpsQuestItem;
	import modulecommon.scene.prop.skill.JinnangIcon;
	import modulecommon.scene.prop.skill.SkillIcon;
	import modulecommon.scene.prop.table.TGuoguanzhanjiangBase;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.scene.zhanxing.WuXueIcon;
	import modulecommon.scene.zhanxing.ZhanxingMgr;
	import modulecommon.time.Daojishi;
	
	import modulecommon.tools.Earthquake;
	import modulecommon.ui.FormConfirmBase;
	import modulecommon.ui.FormStyleEight;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.ui.FormStyleFour;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.FormStyleOne;
	import modulecommon.ui.FormStyleSix;
	import modulecommon.ui.FormStyleThree;
	import modulecommon.ui.FormStyleTwo;
	import modulecommon.ui.FormTitle;
	import modulecommon.uiObject.UIMBeing;
	import modulecommon.uiinterface.IUIBackPack;
	import modulecommon.uiinterface.IUIChat;
	import modulecommon.uiinterface.IUICopiesAwards;
	import modulecommon.uiinterface.IUICopyCountDown;
	import modulecommon.uiinterface.IUICorpsKejiYanjiu;
	import modulecommon.uiinterface.IUICreateNameHero;
	import modulecommon.uiinterface.IUIEquipSys;
	import modulecommon.uiinterface.IUIFuben;
	import modulecommon.uiinterface.IUIGamble;
	import modulecommon.uiinterface.IUIGmPlayerAttributes;
	import modulecommon.uiinterface.IUIGodlyWeapon;
	import modulecommon.uiinterface.IUIHeroSelect;
	import modulecommon.uiinterface.IUILog;
	import modulecommon.uiinterface.IUILogin;
	import modulecommon.uiinterface.IUIMail;
	import modulecommon.uiinterface.IUIMailContent;
	import modulecommon.uiinterface.IUINpcDisappearAni;
	import modulecommon.uiinterface.IUIPropmtOne;
	import modulecommon.uiinterface.IUIRadar;
	import modulecommon.uiinterface.IUIRecruit;
	import modulecommon.uiinterface.IUISanguoZhangchang;
	import modulecommon.uiinterface.IUISceneTran;
	import modulecommon.uiinterface.IUITipInChat;
	import modulecommon.uiinterface.IUITongQueTai;
	import modulecommon.uiinterface.IUITongQueWuHui;
	import modulecommon.uiinterface.IUITurnCard;
	import modulecommon.uiinterface.IUIUprightPrompt;
	import modulecommon.uiinterface.IUIWorldBossSys;
	import modulecommon.uiinterface.IUIYizhelibao;
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiPkCountUserCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.RankItem;
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiPkDaoJiShiUserCmd;
	import modulecommon.net.msg.questUserCmd.stDirectFinishQuestUserCmd;
	import modulecommon.net.msg.questUserCmd.reqXuanShangQuestRewardUserCmd;
	import modulecommon.uiinterface.IUIXuanShangRenWu;
	import modulecommon.net.msg.sceneUserCmd.stNotifyOpenOneFunctionCmd;
	import modulecommon.net.msg.questUserCmd.stReqOpenXuanShangQuestUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stYetOpenNewFunctionUserCmd;
	import modulecommon.uiinterface.IUISaoDangIngInfo;
	import modulecommon.uiinterface.IUIScreenSlide;
	import modulecommon.net.msg.eliteBarrierCmd.stRetSlaveInfoToClietCmd;
	import modulecommon.scene.jiuguan.Baowu;
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerUIInfo;
	import modulecommon.net.msg.sceneHeroCmd.stGainHeroCmd;
	import modulecommon.net.msg.sceneHeroCmd.stReqRicherAndEnemyListCmd;
	import modulecommon.net.msg.sceneUserCmd.updateVipScoreUserCmd;
	import modulecommon.net.msg.propertyUserCmd.stBuyGameTokenPropertyUserCmd;
	
	import modulecommon.uiinterface.IUIFlyAni;
	import modulecommon.uiinterface.IUIGiftPack;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	import modulecommon.net.msg.sceneUserCmd.TestVipRechargeScoreUserCmd;
	import modulecommon.uiinterface.IUIZhanYiResult;
	
	import modulecommon.uiinterface.IUITaskPrompt;
	
	import modulecommon.uiinterface.IUIAniGetGiftObj;
	import modulecommon.net.msg.eliteBarrierCmd.stLeftTiaoZhanOnlineCmd;
	import modulecommon.uiinterface.IUIMapName;
	import modulecommon.uiinterface.IUICloud;
	import modulecommon.uiinterface.IUIInfoTip;
	import modulecommon.net.msg.eliteBarrierCmd.stReqBarrierDataCmd;
	import modulecommon.uiinterface.IUIGZJJChallenge;
	import modulecommon.uiinterface.IUIFndReq;
	import modulecommon.uiinterface.IUIFndLst;
	import modulecommon.uiinterface.IUIFndAdd;
	import modulecommon.uiinterface.IUIFndZhuFu;
	import modulecommon.scene.prop.relation.stUBaseInfo;
	import modulecommon.scene.prop.relation.ItemDataFndAdd;
	import modulecommon.uiinterface.IPersonChat;
	import modulecommon.uiinterface.IUIPersonChat;
	import modulecommon.uiinterface.IUIChatSystem;
	
	import modulecommon.uiinterface.IUICorpsCreate;
	import modulecommon.uiinterface.IUICorpsLst;
	import modulecommon.uiinterface.IUICorpsInfo;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import modulecommon.net.msg.fndcmd.stReqAddFriendByCharIDFriendCmd;
	import modulecommon.net.msg.fndcmd.stDeleteFriendFriendCmd;
	import modulecommon.net.msg.fndcmd.stMoveFriendToBlackListFriendCmd;
	import modulecommon.net.msg.sceneUserCmd.reqViewUserCmd;
	import modulecommon.uiinterface.IUIMenuFnd;
	import modulecommon.ui.FormStyleFive;
	
	import modulecommon.uiinterface.IUIFndFlyAni;
	import modulecommon.uiinterface.IUICorpsCitySys;
	import modulecommon.net.msg.sceneUserCmd.showActivityIconUserCmd;
	import modulecommon.net.msg.corpscmd.notifyCorpsNpcIDUserCmd;
	import modulecommon.net.msg.corpscmd.notifyBeAttackUserCmd;
	import modulecommon.uiinterface.IUIBNotify;
	import modulecommon.net.msg.sceneHeroCmd.stNotifyRobNumberUserCmd;
	import modulecommon.net.msg.sceneHeroCmd.reqDetailRobInfoUserCmd;
	import modulecommon.headtop.TopBlockNpcBattle;
	import modulecommon.scene.prop.table.TGroundObjectItem;
	import modulecommon.scene.prop.table.TMapItem;
	import modulecommon.net.msg.mailCmd.MailHead;
	import modulecommon.net.msg.mailCmd.stRetMailListCmd;
	import modulecommon.uiinterface.IUITeamFBSys;
	import modulecommon.ui.UISubSys;
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;
	import modulecommon.net.msg.teamUserCmd.stNotifyTeamMemberListUserCmd;
	import modulecommon.net.msg.teamUserCmd.synUserTeamStateCmd;
	import modulecommon.net.msg.teamUserCmd.reqAddMultiCopyUserCmd;
	
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.copyUserCmd.stReqBoxTipContextUserCmd;
	import modulecommon.net.msg.chatUserCmd.stRetChatUserInfoCmd;
	import com.gskinner.motion.easing.Cubic;
	import modulecommon.uiinterface.IUIMountsSys;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.net.msg.mountscmd.stActiveMountCmd;
	import modulecommon.net.msg.mountscmd.stMountAdvanceCmd;
	import modulecommon.net.msg.mountscmd.stChangeUserMountCmd;
	import modulecommon.net.msg.mountscmd.stSetRideMountStateCmd;
	import modulecommon.net.msg.mountscmd.stNotifyChangeMountCmd;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.commonfuntion.imloader.ModuleResLoadingItem;
	import modulecommon.uiinterface.IUIBenefitHall;
	import modulecommon.uiinterface.IUIRanklist;
	import modulecommon.net.msg.rankcmd.stReqRankListUserCmd;
	import modulecommon.net.msg.corpscmd.reqIntoCitySceneUserCmd;
	import modulecommon.uiinterface.IUIDaoJiShiWuJiang;
	
	import modulecommon.net.msg.giftCmd.reqOnlineGiftContentUserCmd;
	import modulecommon.net.msg.giftCmd.retOnlineGiftContentUserCmd;
	import modulecommon.net.msg.giftCmd.reqGetOnlineGiftUserCmd;
	import modulecommon.net.msg.copyUserCmd.notifyTouXiangData;
	import modulecommon.net.msg.copyUserCmd.reqTouXiangGiveBaoWu;
	import modulecommon.login.NetISP;
	import modulecommon.net.msg.mountscmd.stViewOtherUserMountCmd;
	import modulecommon.uiinterface.IUIMysteryShop;
	import modulecommon.net.msg.giftCmd.stBuySecretStoreObjCmd;
	import modulecommon.logicinterface.ISceneUIHandle;
	import modulecommon.net.msg.paoshangcmd.reqOpenBusinessUiUserCmd;
	import modulecommon.scene.prop.skill.MountsSkillIcon;
	import modulecommon.scene.beings.MountsSkillTipData;
	import modulecommon.uiinterface.IUILQWJ;
	import modulecommon.uiinterface.IUIVipTiYan;
	import modulecommon.net.msg.activityCmd.getVip3PracticeRewardCmd;
	
	public class RegisterClass_Game 
	{
		
		IUILogin;
		IUIBackPack;
		IUILog;
		IMFight;
		stScenePkCmd;
		IUIChat;
		IUIRadar;
		st7DayRechargeRankListCmd;

		stChatUserCmd;
		MessageBuffer;
		ResGrid9;
		
		stQuestDialogUserCmd;
		stAttackUserCmd;		
		FormStyleOne;
		JinnangIcon;
		stReqAvailableCopyUserCmd;
		IUIFuben;
		Soldier;
		UIMBeing;
		Name_ValueCtrol;
		Icon_ValueCtrol;
		stNpcMoveUserCmd;
		IUIPropmtOne;
		IUIUprightPrompt;
		stWORDPromptUserCmd;
		IUITurnCard;
		IUINpcDisappearAni;
		BubbleWordSprite;
		stPickUpObjTypeNumberPropertyUserCmd;
		stUseObjectPropertyUserCmd
		IUICopiesAwards;
		Earthquake;
		AttrStrip;
		FormStyleTwo;
		stGameTokenUserCmd;
		stReqMaxClearanceIdUserCmd;
		stRetMaxClearanceIdUserCmd;
		IUIGamble;
		stActivityCmd;
		IUIEquipSys;
		Daojishi;
		stRemakeEquipCmd;
		FormStyleThree;
		stEliteBarrierCmd;
		stRetCurBarrierCmd;
		ItemWu;
		IUICopyCountDown;
		FormStyleFour;
		stMailCmd;
		IUIMail;
		IUIRecruit;
		IUISceneTran;
		DelayLoaderMap;
		IUICreateNameHero;
		stRetVerifyUseNameUserCmd;
		stGuanZhiJingJiCmd;
		stReqModifyNameUserCmd;
		stGuanZhiJingJiPkCountUserCmd;
		stRefreshTrialTowerDataCmd;
		TGuoguanzhanjiangBase;
		stTrialTowerCmd;
		RankItem;
		stGuanZhiJingJiPkDaoJiShiUserCmd;
		stSendOnlineDataCmd;
		stReqGiveUpChallengeCmd;
		stDirectFinishQuestUserCmd;
		reqXuanShangQuestRewardUserCmd;
		stNotifyUserStateCmd;
		IUIXuanShangRenWu;
		stNotifyOpenOneFunctionCmd;
		stReqOpenXuanShangQuestUserCmd;
		stYetOpenNewFunctionUserCmd;
		DigitComponent;
		synSaoDangCopyUserCmd;

		IUISaoDangIngInfo;
		retQuickFinishSaoDangYuanBaoUserCmd;
		IUIScreenSlide;
		reqSaoDangCopyUserCmd;
		stRetSlaveInfoToClietCmd;
		stRetOtherClientDebugInfoCmd;
		stReqOtherClientDebugInfoCmd;
		MoneyPanel;
		Baowu;
		stReqTrialTowerUIInfo;
		stGainHeroCmd;
		stReqRicherAndEnemyListCmd;
		FormTitle;
		IUIFlyAni;		
		stNpcAiChatUserCmd;
		stReqYuanBaoCoolingUserCmd;
		retYuanBaoCoolingTimeUserCmd;
		updateVipScoreUserCmd;
		DigitComponentWidthSign;
		IUIGiftPack;
		stGiftCmd;
		stWuNvCmd;
		
		TestVipRechargeScoreUserCmd;
		IUIZhanYiResult;
		stMainUserDataUserCmd;
		IUIAniGetGiftObj;
		stLeftTiaoZhanOnlineCmd;
		IUITaskPrompt;
		IUIMapName;
		IUICloud;
		IUIInfoTip;
		stReqBarrierDataCmd;
		FormConfirmBase;
		IUIGZJJChallenge;
		AniObjectMgr;
		stBuyGameTokenPropertyUserCmd;
		IUIFndReq;
		IUIFndLst;
		IUIFndAdd;
		IUIFndZhuFu;
		WuIcon;
		stSetHeroXiaYeCmd;

		stUBaseInfo;
		ItemDataFndAdd;		
		IPersonChat;
		IUIPersonChat;
		IUIChatSystem;
		stSetUserStateCmd;
		
		IUICorpsCreate;
		IUICorpsLst;
		IUICorpsInfo;
		stCorpsCmd;
		stFriendCmd;
		stReqMailListCmd;
		stReqAddFriendByCharIDFriendCmd;
		stDeleteFriendFriendCmd;
		stMoveFriendToBlackListFriendCmd;
		reqViewUserCmd;
		IUIMenuFnd;
		PanelCombine1;
		stGetPerDayActiveUserCmd;
		stOpenPerDayToDoUserCmd;
		stPerDayRegUserCmd;
		FormStyleSix;
		t_ItemData2;
		KejiItemInfo;
		FormStyleFive;
		IUIFndFlyAni;
		CorpsQuestItem;
		IUIGmPlayerAttributes;
		TipBase;
		IUICorpsCitySys;
		SkillIcon;
		showActivityIconUserCmd;
		notifyCorpsNpcIDUserCmd;
		notifyBeAttackUserCmd;
		reqAssignBoxUiCorpsMemberListUserCmd;
		GemIcon;
		IUIBNotify;
		stNotifyRobNumberUserCmd;
		reqDetailRobInfoUserCmd;
		TopBlockNpcBattle;
		TipEquipBase;
		TipNotEquipObjBase;
		IUITipInChat;
		stShoppingCmd;
		stFirstChargeBoxInfoCmd;
		stFirstChargeBoxStateCmd;
		TGroundObjectItem;
		TMapItem;
		MailHead;
		stRetMailListCmd;
		FormStyleEight;
		MonkeyAndValue;
		FormStyleExitBtn;
		stBuyMarketObjCmd;
		IUITeamFBSys;
		stReqViewMarketGiftBoxCmd;
		FormStyleNine;
		stAttackVictoryInfoUserCmd;
		
		UISubSys;
		stReqCreateCopyUserCmd;
		stTeamCmd;
		reqJoinCorpsUserCmd;
		stNotifyTeamMemberListUserCmd;
		synUserTeamStateCmd;
		stReqFreeLingPaiInfoCmd;
		stRetFreeLingPaiInfoCmd;
		reqAddMultiCopyUserCmd;
		notifyBestCopyPkReviewCopyUserCmd;
		reqBestCopyPkReviewCopyUserCmd;
		CoolDownControl;
		reqQuickCoolDownCorpsUserCmd;
		IUICorpsKejiYanjiu;
		IUIMailContent;
		UserDispatch;
		stHelpFriendIdFriendCmd;
		
		stReqBoxTipContextUserCmd;
		stReqActLiBaoContentCmd;
		stNotifyActLiBaoStateCmd;
		stRetChatUserInfoCmd;
		RadarMgr;
		stResRobCmd;
		IUISanguoZhangchang;
		stReqRebirthCmd;
		stTakeDownFromMatrixCmd;
		ZhanxingMgr;
		stSwapShenBingCmd;
		Cubic;
		stReqLeaveCopyUserCmd;
		IUIWorldBossSys;
		WuXueIcon;
		IUIYizhelibao;
		IUIMountsSys;
		stLevelUpXMAttrXMCmd;
		stLevelUpXMSkillXMCmd;
		stChangeUserSkillXMCmd;
		MountsSys;
		IUITongQueTai;
		IUITongQueWuHui;
		stBuyEquipToHeroCmd;
		modulecommon.net.msg.mountscmd.stActiveMountCmd;
		modulecommon.net.msg.mountscmd.stMountAdvanceCmd;
		modulecommon.net.msg.mountscmd.stChangeUserMountCmd;
		modulecommon.net.msg.mountscmd.stSetRideMountStateCmd;
		modulecommon.net.msg.mountscmd.stNotifyChangeMountCmd;
		reqBeginCorpsFireUserCmd;
		stWearGodlyWeaponCmd;
		IUIGodlyWeapon;
		modulecommon.commonfuntion.imloader.ModuleResLoader;
		modulecommon.commonfuntion.imloader.ModuleResLoadingItem;
		IUIAniRewarded;
		modulecommon.uiinterface.IUIBenefitHall;
		modulecommon.uiinterface.IUIRanklist;
		modulecommon.net.msg.rankcmd.stReqRankListUserCmd;
		modulecommon.net.msg.corpscmd.reqIntoCitySceneUserCmd;
		IPeopleRankPage;
		stReqTrialTowerSortCmd;
		reqTeamBossRankUserCmd;
		

		modulecommon.uiinterface.IUIDaoJiShiWuJiang;
		stBatchMoveObjActionUserCmd;
		modulecommon.uiinterface.IUIDaoJiShiWuJiang;
		IUIArenaSalary;
		modulecommon.net.msg.giftCmd.reqOnlineGiftContentUserCmd;
		modulecommon.net.msg.giftCmd.retOnlineGiftContentUserCmd;
		modulecommon.net.msg.giftCmd.reqGetOnlineGiftUserCmd;
		
		modulecommon.net.msg.copyUserCmd.notifyTouXiangData;
		modulecommon.net.msg.copyUserCmd.reqTouXiangGiveBaoWu;
		modulecommon.login.NetISP;
		modulecommon.net.msg.mountscmd.stViewOtherUserMountCmd;
		modulecommon.uiinterface.IUIPaoShangSys;
		modulecommon.uiinterface.IUIMysteryShop;
		
		modulecommon.net.msg.giftCmd.stBuySecretStoreObjCmd;
		modulecommon.logicinterface.ISceneUIHandle;
		modulecommon.net.msg.paoshangcmd.reqOpenBusinessUiUserCmd;
		stActiveUserActRelationCmd;
		modulecommon.scene.prop.skill.MountsSkillIcon;
		modulecommon.scene.beings.MountsSkillTipData;
		modulecommon.uiinterface.IUILQWJ;
		modulecommon.uiinterface.IUIVipTiYan;
		IUIGWSkill;
		modulecommon.net.msg.activityCmd.getVip3PracticeRewardCmd;
	}

}