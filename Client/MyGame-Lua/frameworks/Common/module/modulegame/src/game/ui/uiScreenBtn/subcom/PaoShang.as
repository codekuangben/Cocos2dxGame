package game.ui.uiScreenBtn.subcom
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.net.msg.paoshangcmd.reqOpenBusinessUiUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * @brief 跑商
	 */
	public class PaoShang extends FunBtnBase
	{
		public function PaoShang(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_PaoShang, parent);
		}

		override public function onInit():void 
		{
			super.onInit();
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			//m_gkContext.m_systemPrompt.prompt("点击跑商");//亲，不用了请删除我，谢谢！
			//if (!m_gkContext.m_rankSys.bOpenPaoShang)
			//{
				var cmd:reqOpenBusinessUiUserCmd = new reqOpenBusinessUiUserCmd();
				m_gkContext.sendMsg(cmd);
			//}
		}
	}
}