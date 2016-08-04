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
	 * 充值返利
	 */
	public class RechargeRebate extends FunBtnBase
	{
		
		public function RechargeRebate(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_RechargeRebate, parent);
		}
		
		override public function onInit():void 
		{
			super.onInit();
			/*if (m_gkContext.m_rechargeRebateMgr.btnEffectFlag)
			{*/
				showEffectAni("ejhuodongteshu.swf");
			//}
			var num:uint = m_gkContext.m_rechargeRebateMgr.actBtnNum();
			if (num!=0)
			{
				setLblCnt(num, ScreenBtnMgr.LBLCNTBGTYPE_Blue);
			}
			
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIRechatge) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIRechatge);
			}
			else
			{
				var form:Form=m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIRechatge);
				form.show();
			}
			
		}
	}

}