package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 战报
	 */
	public class FightBtn extends BtnBase
	{
		
		public function FightBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_Fight, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIBNotify))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIBNotify);
			}
			else
			{
				m_gkContext.m_radarMgr.reqDetailRobInfo();
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIBNotify);
			}
		}
		
	}

}