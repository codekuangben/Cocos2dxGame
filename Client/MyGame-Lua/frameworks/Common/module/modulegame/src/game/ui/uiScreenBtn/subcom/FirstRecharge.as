package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 首充大礼
	 */
	public class FirstRecharge extends FunBtnBase
	{
		
		public function FirstRecharge(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_FirstRecharge, parent);
		}
		
		override public function onClick(event:MouseEvent):void
		{
			super.onClick(event);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIFirstRecharge))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIFirstRecharge);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIFirstRecharge);
			}
			
			hideEffectAni();
		}
	}

}