package modulecommon.headtop 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.worldbossCmd.stBossInfo;
	import modulecommon.scene.beings.NpcVisit;
	/**
	 * ...
	 * @author ...
	 * Npc头顶显示:图标、状态...
	 */
	public class HeadTopNpcStateBase extends HeadTopBlockBase
	{
		protected var m_displayControl:DisplayForWorldBoss;
		protected var m_npc:NpcVisit;
		
		public function HeadTopNpcStateBase(gk:GkContext, npc:NpcVisit) 
		{
			super(gk);
			m_npc = npc;
		}
		
		override public function update():void
		{
			clearAutoData();
			
			if (m_gkContext.m_worldBossMgr.m_bInWBoss || (m_gkContext.m_elitebarrierMgr.m_bInJBoss&&m_npc.npcBase.m_uID!=1054))
			{
				if (m_displayControl != null)
				{
					m_displayControl.dispose();
					m_displayControl = null;
				}
				
				if (m_displayControl == null)
				{
					m_displayControl = new DisplayForWorldBoss(this, m_npc.npcBase.m_uID);
				}
				
				m_displayControl.update();			
			}
			else
			{
				if (m_displayControl != null)
				{
					m_displayControl.dispose();
					m_displayControl = null;
				}
				
				showNormal();
			}
		}
		
		protected function showNormal():void
		{
			//
		}
		
		public function get npc():NpcVisit
		{
			return m_npc;
		}
		
		override public function dispose():void
		{
			if (m_displayControl)
			{
				m_displayControl.dispose();
				m_displayControl = null;
			}
			
			super.dispose();
		}
	}

}