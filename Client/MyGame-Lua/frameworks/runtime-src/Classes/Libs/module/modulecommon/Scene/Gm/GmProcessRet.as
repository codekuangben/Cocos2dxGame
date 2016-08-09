package modulecommon.scene.gm
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.stReqOtherClientDebugInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetOtherClientDebugInfoCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIGmPlayerAttributes;
	
	public class GmProcessRet
	{
		
		private var m_gkContext:GkContext;
		private var m_dicFun:Dictionary;
		
		private var m_strLog:String;
		
		public function GmProcessRet(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicFun = new Dictionary();
			m_dicFun[stRetOtherClientDebugInfoCmd.TYPE_ShowLog] = process_TYPE_ShowLog;
			m_dicFun[stRetOtherClientDebugInfoCmd.TYPE_ShowMsgInChat] = process_TYPE_ShowMsgInChat;
		}
		
		public function process(msg:ByteArray):void
		{
			var rev:stRetOtherClientDebugInfoCmd = new stRetOtherClientDebugInfoCmd();
			rev.deserialize(msg);
			
			if (m_dicFun[rev.type] != undefined)
			{
				m_dicFun[rev.type](rev);
			}
		}
		
		private function process_TYPE_ShowLog(rev:stRetOtherClientDebugInfoCmd):void
		{
			var iFormGM:IUIGmPlayerAttributes = m_gkContext.m_UIMgr.getForm(UIFormID.UIGmPlayerAttributes) as IUIGmPlayerAttributes;
			if (iFormGM)
			{
				var headText:String = rev.srcusername + "(" + rev.srccharid + ")的日志\n";
				m_strLog += headText + rev.text;
				iFormGM.setOtherPlayerLog(m_strLog);
			}
		
		}
		
		private function process_TYPE_ShowMsgInChat(rev:stRetOtherClientDebugInfoCmd):void
		{
			m_gkContext.m_uiChat.appendMsg(rev.text);
			m_gkContext.m_systemPrompt.prompt(rev.text);
		
		}
		
		public function clearLog():void
		{
			m_strLog = "";
		}
	}

}