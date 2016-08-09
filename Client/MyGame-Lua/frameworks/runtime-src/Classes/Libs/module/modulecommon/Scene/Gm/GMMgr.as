package modulecommon.scene.gm 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.stReqOtherClientDebugInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetOtherClientDebugInfoCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class GMMgr 
	{
		private var m_gkContex:GkContext;
		private var m_processReq:GmProcessReq;
		private var m_processRet:GmProcessRet;
		public function GMMgr(gk:GkContext) 
		{
			m_gkContex = gk;
			m_processReq = new GmProcessReq(gk);
			m_processRet = new GmProcessRet(gk);
		}
		
		//被调试的客户端会收到stReqOtherClientDebugInfoCmd
		public function processReqOtherClientDebugInfoCmd(msg:ByteArray):void
		{
			m_processReq.process(msg);			
		}
		
		//只有GM客户端会收到stRetOtherClientDebugInfoCmd，然后调用此函数处理这个数据
		public function processRetOtherClientDebugInfoCmd(msg:ByteArray):void
		{
			m_processRet.process(msg);		
		}
		
		public function clearOtherLog():void
		{
			m_processRet.clearLog();
		}
	}

}