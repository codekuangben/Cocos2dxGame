package modulecommon.scene.corpsduobao 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.corpscmd.reqIntoCorpsTreasureUserCmd;
	/**
	 * 军团夺宝管理器
	 * @author 
	 */
	public class CorpsDuobaoMgr 
	{
		/**
		 * 公共字段
		 */
		private var m_gkcontext:GkContext
		public function CorpsDuobaoMgr(gk:GkContext) 
		{
			m_gkcontext = gk;
		}
		/**
		 * 加载xml
		 */
		public function loadConfig():void
		{
			
		}
		
		//请求进入“军团夺宝”
		public function reqIntoCorpsTreasure():void
		{
			var cmd:reqIntoCorpsTreasureUserCmd = new reqIntoCorpsTreasureUserCmd();
			m_gkcontext.sendMsg(cmd);
		}
		
	}

}