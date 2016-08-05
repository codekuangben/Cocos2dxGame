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
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	public class GmProcessReq
	{
		private var m_gkContext:GkContext;
		private var m_dicFun:Dictionary;
		
		public function GmProcessReq(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicFun = new Dictionary();
			m_dicFun[stReqOtherClientDebugInfoCmd.TYPE_getLog] = process_TYPE_getLog;
			m_dicFun[stReqOtherClientDebugInfoCmd.TYPE_execCode] = process_TYPE_execCode;
			m_dicFun[stReqOtherClientDebugInfoCmd.TYPE_RecordCmd] = process_TYPE_RecordCmd;
			m_dicFun[stReqOtherClientDebugInfoCmd.TYPE_FightSnap] = process_TYPE_FightSnap;
			m_dicFun[stReqOtherClientDebugInfoCmd.TYPE_UIShowInfo] = process_TYPE_UIShowInfo;
		}
		
		public function process(msg:ByteArray):void
		{
			var rev:stReqOtherClientDebugInfoCmd = new stReqOtherClientDebugInfoCmd();
			rev.deserialize(msg);
			
			if (m_dicFun[rev.type] != undefined)
			{
				m_dicFun[rev.type](rev);
			}
			
		}
		
		private function process_TYPE_getLog(rev:stReqOtherClientDebugInfoCmd):void
		{
			var send:stRetOtherClientDebugInfoCmd
			var strLog:String = m_gkContext.m_context.m_logContent;
			
			var startindex:int;
			var str:String;
			while (startindex < strLog.length)
			{
				send = new stRetOtherClientDebugInfoCmd();
				send.dstcharid = rev.srccharid;
				send.dstusername = rev.srcusername;
				send.srccharid = m_gkContext.playerMain.charID;
				send.srcusername = m_gkContext.playerMain.name;
				send.type = stRetOtherClientDebugInfoCmd.TYPE_ShowLog;
				
				send.text = strLog.substr(startindex, 12000);				
				m_gkContext.sendMsg(send);
				
				startindex += 12000;
			}
		}
		
		private function process_TYPE_execCode(rev:stReqOtherClientDebugInfoCmd):void
		{
			var debugForm:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIDebug);
			var bLoad:Boolean;
			m_gkContext.m_contentBuffer.addContent("uiDebug_ReqInfo", rev);
			if (m_gkContext.m_UIPath.getPath(UIFormID.UIDebug) == rev.text)
			{
				if (debugForm)
				{
					debugForm.updateData();
				}
				else
				{
					bLoad = true;
				}
			}
			else
			{
				m_gkContext.m_UIMgr.destroyForm(UIFormID.UIDebug);
				m_gkContext.m_UIPath.setPath(UIFormID.UIDebug, rev.text);
				bLoad = true;
			}
			
			if (bLoad)
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIDebug);
			}
		}
		
		private function process_TYPE_RecordCmd(rev:stReqOtherClientDebugInfoCmd):void
		{
			
		}
		
		private function process_TYPE_FightSnap(rev:stReqOtherClientDebugInfoCmd):void
		{
			m_gkContext.m_battleMgr.m_stopInfo = true;
		}
		
		private function process_TYPE_UIShowInfo(rev:stReqOtherClientDebugInfoCmd):void
		{
			m_gkContext.m_UIMgr.m_showLog = !m_gkContext.m_UIMgr.m_showLog;
		}
	}

}