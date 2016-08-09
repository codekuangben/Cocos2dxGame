package modulecommon.scene.gamble 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.freeXiazhuUserCmd;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class GambleMgr 
	{
		private var m_gkContext:GkContext;
		public var m_maxFree:uint;
		public var m_leftFrees:uint;
		
		public function GambleMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		public function processFreeXiazhuUserCmd(msg:ByteArray, param:uint = 0):void
		{
			var rev:freeXiazhuUserCmd = new freeXiazhuUserCmd();
			rev.deserialize(msg);
			
			m_maxFree = rev.maxFree;
			m_leftFrees = rev.leftFrees;
		}
		
		//更新剩余免费次数
		public function updateLeftFrees():void
		{
			m_leftFrees = (m_leftFrees > 0)? (m_leftFrees - 1): 0;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Gamble, -1, m_leftFrees);
			}
		}
	}

}