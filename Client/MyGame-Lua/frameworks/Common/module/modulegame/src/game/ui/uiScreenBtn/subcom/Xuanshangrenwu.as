package game.ui.uiScreenBtn.subcom 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.net.msg.questUserCmd.stReqOpenXuanShangQuestUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.task.TaskManager;
	import modulecommon.ui.UIFormID;
	import game.ui.uiScreenBtn.UIScreenBtn;
	/**
	 * ...
	 * @author 
	 * 悬赏任务
	 */
	public class Xuanshangrenwu extends FunBtnBase
	{
		
		public function Xuanshangrenwu(parent:DisplayObjectContainer = null)
		{
			super(ScreenBtnMgr.Btn_Xuanshangrenwu, parent)
		}
		
		override public function onInit():void 
		{
			super.onInit();
			setLblCnt(TaskManager.XUANSHANG_MAXCOUNT - m_gkContext.m_taskMgr.receivedCount);
		}
		
		override public function onClick(e:MouseEvent):void
		{
			super.onClick(e);
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIXuanShangRenWu) == true)
			{
				m_gkContext.m_UIMgr.exitForm(UIFormID.UIXuanShangRenWu);
			}
			else
			{
				var send:stReqOpenXuanShangQuestUserCmd = new stReqOpenXuanShangQuestUserCmd();
				m_gkContext.sendMsg(send);
			}
		}
	}

}
