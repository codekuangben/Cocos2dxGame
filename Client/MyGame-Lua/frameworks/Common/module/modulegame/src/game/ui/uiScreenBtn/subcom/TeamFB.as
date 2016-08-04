package game.ui.uiScreenBtn.subcom
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;

	/**
	 * @brief 组队副本
	 * */
	public class TeamFB  extends FunBtnBase
	{
		public function TeamFB(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_TeamFB, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(m_gkContext.m_teamFBSys.leftCounts);
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			
			// 打开组队副本
			if (m_gkContext.m_UIMgr.getForm(UIFormID.UITeamFBSys))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UITeamFBSys);
			}
			else
			{
				m_gkContext.m_teamFBSys.clkBtn = true;
				//m_gkContext.m_UIMgr.showFormEx(UIFormID.UITeamFBSys);
				m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITeamFBSys);
			}
		}

		override public function initData(fileName:String):void
		{
			super.initData(fileName);
		}
	}
}