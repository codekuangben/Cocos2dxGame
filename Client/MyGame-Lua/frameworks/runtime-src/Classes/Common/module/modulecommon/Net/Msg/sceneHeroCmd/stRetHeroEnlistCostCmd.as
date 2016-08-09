package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stRetHeroEnlistCostCmd extends stSceneHeroCmd 
	{
		public var m_vecCost:Vector.<uint>;
		public function stRetHeroEnlistCostCmd() 
		{
			byParam = PARA_RET_HERO_ENLIST_COST_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_vecCost = new Vector.<uint>(3);
			var i:int = 0;
			for (i = 0; i < 3; i++)
			{
				m_vecCost[i] = byte.readUnsignedInt();				
			}
			
		}
	}

}

/*
 * const BYTE PARA_RET_HERO_ENLIST_COST_USERCMD = 16;
	struct stRetHeroEnlistCostCmd : public stSceneHeroCmd
	{
		stRetHeroEnlistCostCmd()
		{
			byParam = PARA_RET_HERO_ENLIST_COST_USERCMD;
			bzero(cost,sizeof(DWORD)*3);
		}
		DWORD cost[3];	//0-绿 1-蓝 2-紫
	};
*/