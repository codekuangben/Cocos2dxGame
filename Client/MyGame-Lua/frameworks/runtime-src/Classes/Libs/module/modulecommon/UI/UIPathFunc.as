package modulecommon.ui
{
	//import com.pblabs.engine.debug.Logger
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIPathFunc
	{
		private var m_dicPath:Dictionary;		
		public function UIPathFunc():void
		{
			m_dicPath = new Dictionary();		
			m_dicPath[UIFormID.UILogin] = "UILogin";			
			m_dicPath[UIFormID.UINpcTalk] = "UINpcTalk";
			m_dicPath[UIFormID.UITask] = "UITask";			
			m_dicPath[UIFormID.UIFuben] = "UIFuben";
			m_dicPath[UIFormID.UIGmPlayerAttributes] = "UIGmPlayerAttributes";
			m_dicPath[UIFormID.UILog] = "UILog";
			m_dicPath[UIFormID.UITip] = "UITip";
			//m_dicPath[UIFormID.UIZhenfa] = "UIZhenfa";	
			m_dicPath[UIFormID.UIAnimationGet] = "UIAnimationGet";
			m_dicPath[UIFormID.UINewhandPrompt] = "UINewhandPrompt";
			m_dicPath[UIFormID.UIPropmtOne] = "UIPropmtOne";
			m_dicPath[UIFormID.UIUprightPrompt] = "UIUprightPrompt";
			m_dicPath[UIFormID.UITurnCard] = "UITurnCard";
			m_dicPath[UIFormID.UICopiesAwards] = "UICopysAwards";
			m_dicPath[UIFormID.UINpcDisappearAni] = "UINpcDisappearAni";
			m_dicPath[UIFormID.UIBattleLog] = "UILog";
			//m_dicPath[UIFormID.UIXingMai] = "UIXingMai";
			m_dicPath[UIFormID.UISelectEmbranchment] = "UISelectEmbranchment";
			m_dicPath[UIFormID.UIJiuGuan] = "UIJiuGuan";
			m_dicPath[UIFormID.UIGamble] = "UIGamble";
			m_dicPath[UIFormID.UIEquipSys] = "UIEquipSys";
			m_dicPath[UIFormID.UIEdit] = "UIEdit";
			m_dicPath[UIFormID.UICangbaoku] = "UICangbaoku";
			m_dicPath[UIFormID.UIBarrierZhenfa] = "UIBarrierZhenfa";
			m_dicPath[UIFormID.UIEliteBarrier] = "UIEliteBarrier";
			m_dicPath[UIFormID.UICopyCountDown] = "UICopyCountDown";
			m_dicPath[UIFormID.UIMail] = "UIMail";
			m_dicPath[UIFormID.UIRecruit] = "UIRecruit";
			m_dicPath[UIFormID.UICreateNameHero] = "UICreateNameHero";
			m_dicPath[UIFormID.UISceneTran] = "UISceneTran";
			m_dicPath[UIFormID.UIArenaWeekReward] = "UIArenaWeekReward";
			m_dicPath[UIFormID.UIArenaInfomation] = "UIArenaInfomation";
			m_dicPath[UIFormID.UIArenaLadder] = "UIArenaLadder";
			m_dicPath[UIFormID.UIArenaStarter] = "UIArenaStarter";
			m_dicPath[UIFormID.UIArenaBetialRank] = "UIArenaBetialRank";
			m_dicPath[UIFormID.UIHeroSelect] = "UIHeroSelect";
			m_dicPath[UIFormID.UIGuoguanzhanjiang] = "UIGuoguanzhanjiang";
			m_dicPath[UIFormID.UIGgzjRank] = "UIGgzjRank";
			m_dicPath[UIFormID.UIGgzjWuList] = "UIGgzjWuList";
			m_dicPath[UIFormID.UIGgzjDie] = "UIGgzjDie";
			m_dicPath[UIFormID.UIXuanShangRenWu] = "UIXuanShangRenWu";
			m_dicPath[UIFormID.UIFubenSaoDang] = "UIFuBenSaoDang";
			m_dicPath[UIFormID.UISaoDangIngInfo] = "UISaoDangIngInfo";
			m_dicPath[UIFormID.UISaoDangReward] = "UISaoDangReward";
			m_dicPath[UIFormID.UIScreenSlide] = "UIScreenSlide";
			m_dicPath[UIFormID.UIWuJiangZhuanShengAni] = "UIWuJiangZhuanShengAni";
			m_dicPath[UIFormID.UIZhanliAddAni] = "UIZhanliAddAni";
			m_dicPath[UIFormID.UISnatchTreasure] = "UISnatchTreasure";
			m_dicPath[UIFormID.UIRecruitPurpleWu] = "UIRecruitPurpleWu";
			m_dicPath[UIFormID.UIFTurnCard] = "UITurnCard";
			m_dicPath[UIFormID.UIFlyAni] = "UIFlyAni";
			m_dicPath[UIFormID.UIFallObjectPicupAni] = "UIFallObjectPicupAni";
			m_dicPath[UIFormID.UIZhanliUpgrade] = "UIZhanliUpgrade";
			m_dicPath[UIFormID.UIZhanliUpgradeWuList] = "UIZhanliUpgradeWuList";
			m_dicPath[UIFormID.UIGiftPack] = "UIGiftPack";
			m_dicPath[UIFormID.UIOtherPlayer] = "UIOtherPlayer";
			m_dicPath[UIFormID.UIZhanYiResult] = "UIZhanYiResult";
			//m_dicPath[UIFormID.UIHeroSelectNew] = "UIHeroSelectNew";
			m_dicPath[UIFormID.UIAniGetGiftObj] = "UIAniGetGiftObj";
			m_dicPath[UIFormID.UICloud] = "UICloud";
			m_dicPath[UIFormID.UIMCloud] = "UICloud";
			m_dicPath[UIFormID.UITaskPrompt] = "UITaskPrompt";
			m_dicPath[UIFormID.UIMapName] = "UIMapName";
			m_dicPath[UIFormID.UIInfoTip] = "UIInfoTip";
			m_dicPath[UIFormID.UIIngotBefall] = "UIIngotBefall";
			m_dicPath[UIFormID.UIGZJJChallenge] = "UIGZJJChallenge";
			m_dicPath[UIFormID.UIFndReq] = "UIFndReq";
			m_dicPath[UIFormID.UIFndLst] = "UIFndLst";
			m_dicPath[UIFormID.UIFndAdd] = "UIFndAdd";
			m_dicPath[UIFormID.UIFndZhuFu] = "UIFndZhuFu";
			m_dicPath[UIFormID.UIChatSystem] = "UIChatSystem";
			m_dicPath[UIFormID.UIDaZuo] = "UIDaZuo";
			m_dicPath[UIFormID.UIWuXiaye] = "UIWuXiaye";
			m_dicPath[UIFormID.UIWuZhuansheng] = "UIWuZhuansheng";
			
			m_dicPath[UIFormID.UICorpsCreate] = "UICorpsCreate";
			m_dicPath[UIFormID.UICorpsLst] = "UICorpsLst";	
			m_dicPath[UIFormID.UICorpsMgr] = "UICorpsMgr";
			m_dicPath[UIFormID.UICorpsDonate] = "UICorpsDonate";
			m_dicPath[UIFormID.UICorpsKejiYanjiu] = "UICorpsKejiYanjiu";
			m_dicPath[UIFormID.UICorpsKejiLearn] = "UICorpsKejiLearn";
			m_dicPath[UIFormID.UIFndFlyAni] = "UIFndFlyAni";
			m_dicPath[UIFormID.UICorpsCitySys] = "UICorpsCitySys";	
			m_dicPath[UIFormID.UIBNotify] = "UIBNotify";
			m_dicPath[UIFormID.UIFirstRecharge] = "UIFirstRecharge";
			m_dicPath[UIFormID.UIAddFriendFight] = "UIAddFriendFight";
			//m_dicPath[UIFormID.UITeamFBSys] = "UITeamFBSys";
			m_dicPath[UIFormID.UIVipPrivilege] = "UIVipPrivilege";
			m_dicPath[UIFormID.UIBuyLingpai] = "UIBuyLingpai";
			m_dicPath[UIFormID.UIGmInfoShow] = "UIGmInfoShow";
			m_dicPath[UIFormID.UIBestCopyPk] = "UIBestCopyPk";
			m_dicPath[UIFormID.UIShoucangGame] = "UIShoucangGame";
			m_dicPath[UIFormID.UICorpsLottery] = "UICorpsLottery";
			m_dicPath[UIFormID.UISanguoZhangchang] = "UISanguoZhangchang";
			m_dicPath[UIFormID.UIZhanxing] = "UIZhanxing";
			m_dicPath[UIFormID.UIYizhelibao] = "UIYizhelibao";
			m_dicPath[UIFormID.UIGmWatch] = "UIGmWatch";
			m_dicPath[UIFormID.UIWorldBossSys] = "UIWorldBossSys";
			m_dicPath[UIFormID.UIMountsSys] = "UIMountsSys";
			m_dicPath[UIFormID.UIGodlyWeapon] = "UIGodlyWeapon";
			m_dicPath[UIFormID.UICGIntro] = "UICGIntro";
			m_dicPath[UIFormID.UIRanklist] = "UIRanklist";
			m_dicPath[UIFormID.UIArenaSalary] = "UIArenaSalary";
		}
		
		public function setPath(id:uint, path:String):void
		{
			m_dicPath[id] = path;
		}

		public function getPath(id:uint):String
		{
			if(m_dicPath[id])
			{
				var ret:String = m_dicPath[id];
				ret = "asset/ui/" + ret + ".swf";
				return ret;
			}
			
			return null;
		}
	}
}