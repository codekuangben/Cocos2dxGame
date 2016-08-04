package game.ui.uipaoshangsys.start
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import game.ui.uipaoshangsys.DataPaoShang;
	//import game.ui.uipaoshangsys.msg.notifyBusinessDataUserCmd;
	import game.ui.uipaoshangsys.msg.reqBeginBusinessUserCmd;
	import game.ui.uipaoshangsys.msg.stRetBusinessUiDataUserCmd;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.PushButton;
	import modulecommon.uiinterface.IUIPaoShangSys;
	
	/**
	 * @brief
	 */
	public class UIStart extends Form
	{
		public var m_DataPaoShang:DataPaoShang;
		public var m_pnlCS:Panel;
		private var m_lblCnt:Label;					// 次数
		protected var m_btnStart:PushButton;
		
		public function UIStart()
		{
			this.id = UIFormID.UIStart;
			this.setSize(200, 80);
		}
		
		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			m_pnlCS = new Panel(this);
			m_lblCnt = new Label(this, 120, 13, "次数", UtilColor.COLOR2);
			
			m_btnStart = new PushButton(this, 0, 42, onBtnStart);
			if ((m_DataPaoShang.m_form as IUIPaoShangSys).isResReady())
			{
				initRes();
			}
		}
		
		override public function exit():void
		{
			m_DataPaoShang.m_onUIClose(this.id);
			super.exit();
		}
		
		private function onBtnStart(event:MouseEvent):void
		{
			var cmd:reqBeginBusinessUserCmd = new reqBeginBusinessUserCmd();
			m_DataPaoShang.m_gkcontext.sendMsg(cmd);
			
			exit();
		}
		
		public function initRes():void
		{
			m_btnStart.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.btn2");
			m_pnlCS.setPanelImageSkinBySWF(m_DataPaoShang.m_form.swfRes, "uipaoshang.jinricishu");
		}
		
		//public function psnotifyBusinessDataUserCmd(msg:notifyBusinessDataUserCmd):void
		//{
		//	m_lblCnt.text = msg.times + "/2";
		//}
		
		public function psstRetBusinessUiDataUserCmd(msg:stRetBusinessUiDataUserCmd):void
		{
			m_lblCnt.text = msg.times + "/2";
		}
	}
}