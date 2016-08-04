package game.ui.uiScreenBtn.subcom
{
	/**
	 * ...
	 * @author
	 */
	import game.ui.uiScreenBtn.UIScreenBtn;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	
	public class Jiuguan extends FunBtnBase
	{
		
		public function Jiuguan(parent:DisplayObjectContainer = null)
		{
			super(ScreenBtnMgr.Btn_Jiuguan, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			
			m_bNeedHide = false;
		}
		
		override public function onClick(e:MouseEvent):void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_newHandMgr.promptOver();
			}
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIJiuGuan) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIJiuGuan);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIJiuGuan);
			}
			
		}
	
	}

}