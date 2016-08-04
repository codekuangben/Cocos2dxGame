package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author ...
	 * 排名信息
	 */
	public class RanksBtn extends BtnBase
	{
		public function RanksBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_Ranks, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			// m_gkContext.m_systemPrompt.prompt("排名信息");
			if (true == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRanklist))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIRanklist);
			}
			else
			{
				m_gkContext.m_UIMgr.showFormEx(UIFormID.UIRanklist);
			}
		}
	}
}