package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uibenefithall.UIBenefitHall;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * @brief 福利大厅
	 */
	public class BenefitHall extends FunBtnBase
	{	
		public function BenefitHall(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_BenefitHall, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			
			m_bNeedHide = false;
			
			if (m_gkContext.m_benefitHallMgr.hasRewardInBenefitHall())
			{
				showEffectAni();
			}
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIBenefitHall))
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIBenefitHall);
			}
			else
			{
				var form:UIBenefitHall = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIBenefitHall) as UIBenefitHall;
				if (form)
				{
					form.openPage(form.getPageId());
				}
			}			
		}
	}

}