package game.process 
{
	/**
	 * ...
	 * @author 
	 * 过关斩将（试练塔）
	 */
	//import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.trialTowerCmd.stNotifyUserStateCmd;
	import modulecommon.net.msg.trialTowerCmd.stSendOnlineDataCmd;
	import modulecommon.net.msg.trialTowerCmd.stTrialTowerCmd;
	import modulecommon.net.msg.trialTowerCmd.stRefreshTrialTowerDataCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	//import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	
	public class GuoguanzhanjiangProcess extends ProcessBase 
	{		
		public function GuoguanzhanjiangProcess(gk:GkContext)
		{
			super(gk);
			dicFun[stTrialTowerCmd.REFRESH_TRIAL_TOWER_DATA_PARA] = m_gkContext.m_ggzjMgr.processRefreshTrialTowerDataCmd;
			dicFun[stTrialTowerCmd.RET_TRIAL_TOWER_UIINFO_PARA] = processRetTrialTowerUIInfo;
			dicFun[stTrialTowerCmd.NOTIFY_USER_STATE_PARA] = processNotifyUserStateCmd;
			dicFun[stTrialTowerCmd.SEND_ONLINE_DATA_PARA] = m_gkContext.m_ggzjMgr.processSendOnlineDataCmd;
			dicFun[stTrialTowerCmd.RET_TRIAL_TOWER_SORT_PARA] = processRetTrialTowerSortCmd;
			dicFun[stTrialTowerCmd.NOTIFY_HERO_LEFT_HP_PER_PARA] = processNotifyHeroLeftHpPerCmd;
		}	
		
		private function processNotifyUserStateCmd(msg:ByteArray, param:uint):void
		{
			//主角的死亡，复活			
			var rev:stNotifyUserStateCmd = new stNotifyUserStateCmd();
			rev.deserialize(msg);
			var strLog:String = "过关斩将：收到死亡状态消息stNotifyUserStateCmd state="+rev.state;
			m_gkContext.addLog(strLog);
			if (rev.state == 1)
			{				
				m_gkContext.playerMain.grayChange(true);
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGgzjDie);				
				m_gkContext.m_ggzjMgr.m_bDie = true;
			}
			else
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIGgzjDie);
				m_gkContext.playerMain.grayChange(false);
				m_gkContext.m_ggzjMgr.m_bDie = false;
			}
			
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIGgzjWuList) as IForm;
			if (ui&&rev.state == 1)
			{
				ui.updateData(2);
			}
			else if (ui&&rev.state == 0)
			{
				ui.updateData(3);
			}
			
		}
		private function processRetTrialTowerUIInfo(msg:ByteArray, param:uint):void
		{
			m_gkContext.m_contentBuffer.addContent("uiGuoguanzhanjiang_UIInfo", msg);
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGuoguanzhanjiang);
		}
				
		private function processRetTrialTowerSortCmd(msg:ByteArray, param:uint):void
		{
			m_gkContext.m_contentBuffer.addContent("uiGgzjRank_UIInfo", msg);
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIGgzjRank);
		}
		
		private function processNotifyHeroLeftHpPerCmd(msg:ByteArray, param:uint):void
		{
			m_gkContext.m_contentBuffer.addContent("uiGgzjWuList_info", msg);
			var ui:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIGgzjWuList)as IForm;
			if (ui)
			{
				ui.updateData(0);
			}
		}
	}

}