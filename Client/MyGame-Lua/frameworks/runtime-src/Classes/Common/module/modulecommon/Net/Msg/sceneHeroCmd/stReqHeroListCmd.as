package modulecommon.net.msg.sceneHeroCmd 
{
	import modulecommon.net.msg.sceneHeroCmd.stSceneHeroCmd;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stReqHeroListCmd extends stSceneHeroCmd 
	{
		
		public function stReqHeroListCmd() 
		{
			byParam = PARA_REQ_HERO_LIST_USERCMD;
		}
		
	}

}

/*
 * const BYTE PARA_REQ_HERO_LIST_USERCMD = 4;
	struct stReqHeroListCmd : public stSceneHeroCmd
	{
		stReqHeroListCmd()
		{
			byParam = PARA_REQ_HERO_LIST_USERCMD;
		}
	};
*/
