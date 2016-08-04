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
	 * 寻宝
	 */
	public class TreasureHunting extends FunBtnBase
	{
		public function TreasureHunting(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_TreasureHunting, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UITreasureHunt) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UITreasureHunt);
			}
			else
			{
				var form:Form=m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITreasureHunt);
				form.show();
			}
		}
	}

}