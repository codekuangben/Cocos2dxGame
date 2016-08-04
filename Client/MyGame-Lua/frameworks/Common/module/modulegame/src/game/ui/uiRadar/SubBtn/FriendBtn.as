package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 好友
	 */
	public class FriendBtn extends BtnBase
	{
		
		public function FriendBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_Friend, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			super.onBtnClick(event);
			
			if (true == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIFndLst))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIFndLst);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIFndLst);
			}
		}
	}
}