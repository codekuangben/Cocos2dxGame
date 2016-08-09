package com.pblabs.engine.idleprocess 
{
	/**
	 * ...
	 * @author 
	 */
	public class IdleTimeProcessMgr 
	{
		private var m_processList:Vector.<IIdleTimeProcess>;
		
		public function IdleTimeProcessMgr() 
		{
			m_processList = new Vector.<IIdleTimeProcess>();
		}
		public function process():void
		{
			if (m_processList.length == 0)
			{
				return;
			}
			
			var processItem:IIdleTimeProcess = m_processList[0];
			processItem.process();
		}
		public function insertProcess(process:IIdleTimeProcess):void
		{
			if (m_processList.indexOf(process) == -1)
			{
				m_processList.push(process);
			}
		}
		
		public function deleteProcess(process:IIdleTimeProcess):void
		{
			var i:int = m_processList.indexOf(process);
			if (i != -1)
			{
				m_processList.splice(i, 1);
			}
		}		
	}

}