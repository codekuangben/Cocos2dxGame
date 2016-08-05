package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqHeroEnlistCostCmd extends stSceneHeroCmd 
	{
		
		public function stReqHeroEnlistCostCmd() 
		{
			byParam = PARA_REQ_HERO_ENLIST_COST_USERCMD;
		}
		
	}

}

/*
 * const BYTE PARA_REQ_HERO_ENLIST_COST_USERCMD = 15;
	struct stReqHeroEnlistCostCmd :public stSceneHeroCmd
	{
		stReqHeroEnlistCostCmd()
		{
			byParam = PARA_REQ_HERO_ENLIST_COST_USERCMD;
		}
	};
*/