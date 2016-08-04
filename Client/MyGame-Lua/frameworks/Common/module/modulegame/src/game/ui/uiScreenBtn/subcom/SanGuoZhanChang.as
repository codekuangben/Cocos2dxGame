package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class SanGuoZhanChang extends FunBtnBase 
	{
		
		public function SanGuoZhanChang(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_Sanguozhanchang, parent);			
			
		}
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(m_gkContext.m_sanguozhanchangMgr.timesOfReward);
		}
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UISanguoZhangchangEnter))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UISanguoZhangchangEnter);
			}
			else
			{
				var form:Form=m_gkContext.m_UIMgr.createFormInGame(UIFormID.UISanguoZhangchangEnter);
				form.show();
			}			
		}
	}

}