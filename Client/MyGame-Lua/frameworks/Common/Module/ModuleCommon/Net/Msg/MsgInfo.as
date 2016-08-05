package modulecommon.net.msg 
{
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class MsgInfo 
	{
		private static var m_bInited:Boolean=false; 
		public function MsgInfo()
		{
			
		}
		
		public static function initMsg():void
		{
			if (m_bInited == true)
			{
				return;
			}
			m_bInited = true;
			stSceneHeroCmd.initMsg();
			stSceneUserCmd.initMsg();
			stCorpsCmd.initMsg();
		}
		
	}

}