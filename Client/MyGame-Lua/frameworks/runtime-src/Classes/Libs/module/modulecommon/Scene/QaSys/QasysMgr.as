package modulecommon.scene.qasys 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.stNotifyAnswerQuestionQuestNpcInfoCmd;
	/**
	 * 问答系统mgr 唯一作用就是存放npc信息
	 * @author 
	 */
	public class QasysMgr 
	{
		private var m_gkcontext:GkContext;
		public var m_npcInfo:stNotifyAnswerQuestionQuestNpcInfoCmd;
		public function QasysMgr(gk:GkContext) 
		{
			m_gkcontext = gk;
		}
		public function process_stNotifyAnswerQuestionQuestNpcInfoCmd(msg:ByteArray):void
		{
			m_npcInfo = new stNotifyAnswerQuestionQuestNpcInfoCmd();
			m_npcInfo.deserialize(msg);
		}
		
	}

}