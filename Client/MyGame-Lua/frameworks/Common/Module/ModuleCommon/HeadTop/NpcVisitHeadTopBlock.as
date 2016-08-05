package modulecommon.headtop 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.NpcVisit;
	
	
	public class NpcVisitHeadTopBlock extends HeadTopNpcStateBase 
	{
		
		public function NpcVisitHeadTopBlock(gk:GkContext, npc:NpcVisit) 
		{
			super(gk, npc);
		}
		
		override protected function showNormal():void
		{
			this.clearAutoData();
			
			var color:uint = 0xffffff;
			if (m_npc.canAttacked)
			{
				color = 0xe60000;
			}
			else
			{
				color = 0xfff000;
			}
			
			addAutoData(m_npc.name, color, 14);
			
			if (m_gkContext.m_localMgr.isSet(LocalDataMgr.LOCAL_GM_ShowNPCID))
			{
				addAutoData("npcID "+m_npc.npcBase.m_uID, color, 14);
			}
		}
		
	}

} 