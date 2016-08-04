package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 财神降临
	 */
	public class IngotBefall extends FunBtnBase
	{
		
		public function IngotBefall(parent:DisplayObjectContainer = null) 
		{
			super(ScreenBtnMgr.Btn_IngotBefall, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			
			m_bNeedHide = false;
			
			setLblCnt(m_gkContext.m_ingotbefallMgr.leftFrees);
		}
		
		override public function onClick(event:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.promptOver();
			}
			
			if (true == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIIngotBefall))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIIngotBefall);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIIngotBefall);
			}
		}
	}

}