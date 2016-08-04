package game.ui.uiRadar.SubBtn 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.radar.RadarMgr;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 * 邮件
	 */
	public class MailBtn extends BtnBase
	{
		
		public function MailBtn(parent:DisplayObjectContainer) 
		{
			super(RadarMgr.RADARBTN_Mail, parent);
		}
		
		override protected function onBtnClick(event:MouseEvent):void
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIMail))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIMail);
			}
			else
			{
				m_gkContext.m_radarMgr.reqMail();
			}
		}
	}

}