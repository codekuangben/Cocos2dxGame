package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * 定时充值返利
	 * @author 
	 */
	public class DTRechargeRebate extends FunBtnBase 
	{
		
		public function DTRechargeRebate(parent:DisplayObjectContainer=null) 
		{
			super(ScreenBtnMgr.Btn_DTRechargeRebate, parent);
			
		}
		override public function onInit():void 
		{
			super.onInit();
			if (m_gkContext.m_dtRechargeRebateMgr.btnEffectFlag)
			{
				showEffectAni();
			}
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIDTRechatge) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIDTRechatge);
			}
			else
			{
				var form:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIDTRechatge);
				form.show();
			}
			
		}
	}

}