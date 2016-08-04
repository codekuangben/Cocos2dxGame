package game.ui.uiScreenBtn.subcom 
{
	/**
	 * ...
	 * @author 
	 * 过关斩将表
	 */
	import modulecommon.net.msg.trialTowerCmd.stReqTrialTowerUIInfo;
	import game.ui.uiScreenBtn.UIScreenBtn;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	public class Guoguanzhanjiang extends FunBtnBase 
	{
		
		public function Guoguanzhanjiang(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_Guoguanzhanjiang, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(m_gkContext.m_ggzjMgr.m_timeChallenge);
		}
		
		override public function onClick(e:MouseEvent):void
		{
			super.onClick(e);
			
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIGuoguanzhanjiang) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIGuoguanzhanjiang);
			}
			else
			{
				var send:stReqTrialTowerUIInfo = new stReqTrialTowerUIInfo();
				m_gkContext.sendMsg(send);
				//m_gkContext.m_UIMgr.loadForm(UIFormID.UIGuoguanzhanjiang);
			}
		}
	}

}