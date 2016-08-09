package game.process 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.*;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.wu.WuMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIBNotify;
	import modulecommon.scene.infotip.InfoTip;

	public class HeroProcess 
	{
		private var m_gkcontext:GkContext;		
		private var dicFun:Dictionary;
		private var m_wuMgr:WuMgr;
		private var m_zhenfaMgr:ZhenfaMgr;
		public function HeroProcess(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_wuMgr = m_gkcontext.m_wuMgr;
			m_zhenfaMgr = m_gkcontext.m_zhenfaMgr;
			
			dicFun = new Dictionary();
			dicFun[stSceneHeroCmd.PARA_HERO_DATA_USERCMD] = m_wuMgr.updateHeroProperty;
			dicFun[stSceneHeroCmd.PARA_RET_HERO_LIST_USERCMD] = m_wuMgr.loadAllWuPropery;	
			dicFun[stSceneHeroCmd.PARA_HERO_MAINDATA_USERCMD] = m_wuMgr.addWu;
			//dicFun[stSceneHeroCmd.PARA_HEROCOLOR_CHANGE_USERCMD] = m_wuMgr.changeWuColor;
			
			dicFun[stSceneHeroCmd.PARA_RET_MATRIX_INFO_USERCMD] = m_zhenfaMgr.initData;
			dicFun[stSceneHeroCmd.PARA_SET_HERO_POSITION_USERCMD] = m_zhenfaMgr.setWuPos;
			dicFun[stSceneHeroCmd.PARA_SET_JINNANG_USERCMD] = m_zhenfaMgr.setJinnangPos;
			dicFun[stSceneHeroCmd.PARA_RET_KITLIST_USERCMD] = m_zhenfaMgr.setJinnangList;
			dicFun[stSceneHeroCmd.PRAR_TAKEDOWN_FROM_MATRIX_USERCMD] = m_zhenfaMgr.takeDownFromZhenfa;
			dicFun[stSceneHeroCmd.PARA_TAKEDOWN_KIT_USERCMD] = m_zhenfaMgr.takeDownKit;
			dicFun[stSceneHeroCmd.PARA_NOTIFY_OPEN_ZHENWEI_USERCMD] = m_zhenfaMgr.processNotifyOpenZhenWeiCmd;
			
			//dicFun[stSceneHeroCmd.PARA_RET_HERO_ENLIST_COST_USERCMD] = m_gkcontext.m_jiuguanMgr.processHeroEnlistCostCmd;
			dicFun[stSceneHeroCmd.PARA_JIUGUAN_HEROLIST_USERCMD] = m_gkcontext.m_jiuguanMgr.processJiuGuanHeroListUserCmd;
			dicFun[stSceneHeroCmd.PARA_ADDHERO_TO_JIUGUAN_USERCMD] = m_gkcontext.m_jiuguanMgr.processAddHeroToJiuGuanUserCmd;
			dicFun[stSceneHeroCmd.PARA_RET_RICHER_AND_ENEMY_LIST_USERCMD] = m_gkcontext.m_jiuguanMgr.processRicherAndEnemyListCmd;
			dicFun[stSceneHeroCmd.PARA_BUY_ROBTIMES_COST_USERCMD] = m_gkcontext.m_jiuguanMgr.processBuyRobtimesCostUserCmd;
			dicFun[stSceneHeroCmd.PARA_AFTER_ROB_SHOW_TIPS_USERCMD] = m_gkcontext.m_jiuguanMgr.processAfterRobShowTipsUserCmd;
			dicFun[stSceneHeroCmd.PARA_REFRESH_HERONUM_USERCMD] = m_wuMgr.processRefreshHeroNumCmd;
			dicFun[stSceneHeroCmd.PARA_REMOVE_HERO_USERCMD] = m_wuMgr.processRemoveHeroCmd;
			dicFun[stSceneHeroCmd.PARA_RET_REBIRTH_SUCCESS_USERCMD] = m_wuMgr.processReBirthSuccessCmd;
			dicFun[stSceneHeroCmd.PARA_VIEWED_HERO_LIST_USERCMD] = m_gkcontext.m_watchMgr.processViewedHeroListCmd;
			dicFun[stSceneHeroCmd.GM_PARA_VIEWED_HERO_LIST_USERCMD] = m_gkcontext.m_gmWatchMgr.processstGmViewedHeroListCmd;
			dicFun[stSceneHeroCmd.PARA_LEFT_ROBTIMES_ONLINE_USERCMD] = m_gkcontext.m_jiuguanMgr.processLeftRobtimesOnlineUserCmd;
			dicFun[stSceneHeroCmd.PARA_ROB_ENEMY_TIMES_HERO_CMD] = m_gkcontext.m_jiuguanMgr.processRobEnemyTimesHeroCmd;
			dicFun[stSceneHeroCmd.PARA_SET_HERO_XIAYE_USERCMD] = m_wuMgr.processSetHeroXiaYeCmd;
			dicFun[stSceneHeroCmd.PARA_RET_HEROTRAINING_INFO_USERCMD] = m_wuMgr.processRetHeroTrainingInfoUserCmd;
			dicFun[stSceneHeroCmd.PARA_ADD_HERO_PURPLE_HEROLIST_USERCMD] = m_gkcontext.m_jiuguanMgr.processAddHeroPurpleHerolistUserCmd;
			dicFun[stSceneHeroCmd.PARA_PURPLE_HEROLIST_USERCMD] = m_gkcontext.m_jiuguanMgr.processPurpleHerolistUserCmd;
			dicFun[stSceneHeroCmd.NOTIFY_ROB_NUMBER_USERCMD] = psstNotifyRobNumberUserCmd;
			dicFun[stSceneHeroCmd.RET_DETAIL_ROB_INFO_USERCMD] = psretDetailRobInfoUserCmd;
			dicFun[stSceneHeroCmd.PARA_HERO_REBIRHT_CACHE_HERO_EQUIP_CMD] = m_gkcontext.m_objMgr.process_stHeroRebirthCacheHeroEquipCmd;
			dicFun[stSceneHeroCmd.PARA_PUT_CACHE_EQUIP_TO_REBIRTH_HERO_CMD] = m_gkcontext.m_objMgr.process_stPutCacheEquipToRebirthHeroCmd;
		}
		public function process(msg:ByteArray, param:uint):void
		{
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg);
			}
		}
		
		public function psstNotifyRobNumberUserCmd(msg:ByteArray):void
		{
			var cmd:stNotifyRobNumberUserCmd = new stNotifyRobNumberUserCmd();
			cmd.deserialize(msg);
			var form:IUIBNotify = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBNotify) as IUIBNotify;
			if (cmd.count)	// 如果有内容
			{
				if(form)	// 直接请求
				{
					var reqcmd:reqDetailRobInfoUserCmd = new reqDetailRobInfoUserCmd();
					m_gkcontext.sendMsg(reqcmd);
				}
				else
				{
					m_gkcontext.m_commonProc.addInfoTip(InfoTip.ENBNotify, cmd.count);
				}
				
				// 都要保存一下，除非 count 变为 0 就删除
				m_gkcontext.m_contentBuffer.addContent("stNotifyRobNumberUserCmd", cmd);
			}
			else
			{
				m_gkcontext.m_contentBuffer.delContent("stNotifyRobNumberUserCmd");
			}
		}
		
		public function psretDetailRobInfoUserCmd(msg:ByteArray):void
		{
			var form:IUIBNotify = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBNotify) as IUIBNotify;
			if(form)
			{
				form.psretDetailRobInfoUserCmd(msg);
			}
			else	// 保存起来
			{
				m_gkcontext.m_contentBuffer.addContent("retDetailRobInfoUserCmd", msg);
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIBNotify);
			}
		}
	}
}