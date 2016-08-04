package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 系统设置 //当前仅有"网络设置"
	 */
	public class SystemBtn extends BtnBase
	{
		
		public function SystemBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_System, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			// 系统设置
			if (false == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UISysConfig))
			{
				var uiSysConfig:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UISysConfig);
				if (uiSysConfig)
				{
					uiSysConfig.show();
				}
			}
			else
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UISysConfig);
			}
		}
		
	}

}