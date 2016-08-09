package game.process 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIPaoShangSys;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PaoShangProcess  extends ProcessBase
	{	
		public function PaoShangProcess(gk:GkContext) 
		{
			super(gk);
			//dicFun[stBusinessCmd.NOTIFY_BUSINESS_DATA_USERCMD] = psnotifyBusinessDataUserCmd;
			dicFun[stBusinessCmd.RET_BUSINESS_UI_DATA_USERCMD] = psstRetBusinessUiDataUserCmd;
			dicFun[stBusinessCmd.RET_BEGIN_BUSINESS_USERCMD] = psretBeginBusinessUserCmd;
			dicFun[stBusinessCmd.RET_START_BUSINESS_USERCMD] = psretStartBusinessUserCmd;
			//dicFun[stBusinessCmd.ADD_ONE_ROBER_INFO_USERCMD] = psaddOneRoberInfoUserCmd;
		}
		
		//protected function psnotifyBusinessDataUserCmd(msg:ByteArray, param:uint):void
		//{
		//	var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
		//	if (!uipaoshang)
		//	{
		//		uipaoshang = this.m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
		//		//uipaoshang.show();
		//	}
			
		//	if (uipaoshang)
		//	{
		//		uipaoshang.psnotifyBusinessDataUserCmd(msg);
		//	}
		//}
		
		protected function psstRetBusinessUiDataUserCmd(msg:ByteArray, param:uint):void
		{
			var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
			if (!uipaoshang)
			{
				uipaoshang = this.m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
				//uipaoshang.show();
			}
			
			//var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
			if (uipaoshang)
			{
				uipaoshang.psstRetBusinessUiDataUserCmd(msg);
			}
		}
		
		protected function psretBeginBusinessUserCmd(msg:ByteArray, param:uint):void
		{
			var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
			if (uipaoshang)
			{
				uipaoshang.psretBeginBusinessUserCmd(msg);
			}
		}
		
		protected function psretStartBusinessUserCmd(msg:ByteArray, param:uint):void
		{
			var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
			if (uipaoshang)
			{
				uipaoshang.psretStartBusinessUserCmd(msg);
			}
		}
		
		// 如果进入跑商后，有人打劫，会发过来新的消息
		//protected function psaddOneRoberInfoUserCmd(msg:ByteArray, param:uint):void
		//{
		//	var uipaoshang:IUIPaoShangSys = this.m_gkContext.m_UIMgr.getForm(UIFormID.UIPaoShangSys) as IUIPaoShangSys;
		//	if (!uipaoshang)
		//	{
		//		uipaoshang.psaddOneRoberInfoUserCmd(msg);
		//	}
		//}
	}
}