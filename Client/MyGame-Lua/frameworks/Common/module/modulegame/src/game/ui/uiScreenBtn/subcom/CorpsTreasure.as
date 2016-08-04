package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 军团夺宝
	 */
	public class CorpsTreasure extends FunBtnBase
	{
		
		public function CorpsTreasure(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_CorpsTreasure, parent);
			
		}
		
		override public function onInit():void 
		{
			super.onInit();
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsTreasureEnter))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UICorpsTreasureEnter);
			}
			else
			{
				var form:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UICorpsTreasureEnter);
				form.show();
			}
		}
	}

}