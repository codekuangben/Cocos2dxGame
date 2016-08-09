package modulecommon.scene.guanguanzhanjiang 
{
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.GkContext;
	import modulecommon.net.msg.trialTowerCmd.stRefreshTrialTowerDataCmd;
	import modulecommon.net.msg.trialTowerCmd.stSendOnlineDataCmd;
	import modulecommon.scene.benefithall.peoplerank.PeopleRankMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author 
	 */
	public class GgzjMgr 
	{
		//------过关斩将(试练塔)
		
		private var m_gkContext:GkContext;
		private var m_bInMap:Boolean;	//true-表示当前在过关斩将地图中
		public var m_timeChallenge:int;	//当天可挑战的次数			
		public var m_guzjCurLayer:int;	//zero-base	//当前层数
		protected var m_historylayer:int;	//过关斩将历史最高层
		public var m_bGuzjInChallenge:Boolean;
		public var m_bGuzjFree:Boolean;		//true - 免费重头再来
		public var m_bDie:Boolean;	//true - 死亡
		public var m_guzjMaxLayer:uint;	//过关斩将最大层数
		//------
		public function GgzjMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bDie = false;
		}
		public function dayRefresh():void
		{
			m_timeChallenge = 1;
		}
		
		public function get inMap():Boolean
		{
			return m_bInMap;
		}
		
		public function onLoadWu():void
		{
			if (m_bInMap)
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIGgzjWuList);
			}
		}
		//进入过关斩将地图
		public function enterIn():void
		{
			m_bInMap = true;
			if (m_bGuzjInChallenge == false)
			{
				m_bGuzjInChallenge = true;
			}
			//m_gkContext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			m_gkContext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkContext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			m_gkContext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkContext.m_taskMgr.hideUITaskTrace();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			
			if (m_gkContext.m_wuMgr.loaded==false)
			{
				//m_gkContext.m_wuMgr.requestAllWu();
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIGgzjWuList);
			}
			
			if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGgzjExpReward))
			{
				var form:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIGgzjExpReward);
				form.show();
			}
		}
		
		
		//离开过关斩将地图
		public function leave():void
		{
			m_bInMap = false;
			m_bDie = false;
			//m_gkContext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			m_gkContext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkContext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			
			m_gkContext.playerMain.grayChange(false);
			m_gkContext.m_UIMgr.destroyForm(UIFormID.UIGgzjDie);
			m_gkContext.m_UIMgr.destroyForm(UIFormID.UIGgzjWuList);
			m_gkContext.m_UIMgr.destroyForm(UIFormID.UIGgzjExpReward);
			m_gkContext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkContext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			
			m_gkContext.m_taskMgr.showUITaskTrace();
		}
		
		public function processSendOnlineDataCmd(msg:ByteArray, param:uint):void
		{
			var rev:stSendOnlineDataCmd = new stSendOnlineDataCmd();
			rev.deserialize(msg);
			m_timeChallenge = rev.m_tzTimes;
			m_bGuzjInChallenge = rev.m_bInChallenge;
			m_historylayer = rev.m_historylayer;
			var ui:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIGuoguanzhanjiang);
			if(ui)
			{
				ui.updateData();
			}
		}
		
		public function processRefreshTrialTowerDataCmd(msg:ByteArray, param:uint):void
		{
			var rev:stRefreshTrialTowerDataCmd = new stRefreshTrialTowerDataCmd();
			rev.deserialize(msg);
			
			switch(rev.type)
			{
				case 4:
					m_timeChallenge = rev.value;
					if (m_gkContext.m_UIs.taskPrompt)
					{
						m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_TRIALTOWER, -1, rev.value);
					}
					if (m_gkContext.m_UIs.screenBtn)
					{
						m_gkContext.m_UIs.screenBtn.updateLblCnt(rev.value, ScreenBtnMgr.Btn_Guoguanzhanjiang);
					}
					break;
				case 1:
					m_guzjCurLayer = rev.value;
					break;				
				case 2:
					
					var oldHistorylayer:int = m_historylayer;
					m_historylayer = rev.value;
					if (m_historylayer > oldHistorylayer)
					{
						m_gkContext.m_peopleRankMgr.onValueUp(PeopleRankMgr.RANKTYPE_Guoguan);
					}
					break;
				case 3:
					m_bGuzjFree = (rev.value == 0 ? false:true);
					break;
			}
			
			var ui:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIGuoguanzhanjiang);
			if(ui)
			{
				ui.updateData();
			}
		}
		
		public function get historylayer():int
		{
			return m_historylayer;
		}
	}

}