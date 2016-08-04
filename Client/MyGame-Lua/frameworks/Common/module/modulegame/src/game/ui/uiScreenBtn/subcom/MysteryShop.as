package game.ui.uiScreenBtn.subcom
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMysteryShop;
	/**
	 * ...
	 * @author ...
	 */
	public class MysteryShop extends FunBtnBase
	{
		public function MysteryShop(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_MysteryShop, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIMysteryShop))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIMysteryShop);
			}
			else
			{
				var form:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIMysteryShop);
				if (form)
				{
					form.show();
				}
			}
		}
	}
}