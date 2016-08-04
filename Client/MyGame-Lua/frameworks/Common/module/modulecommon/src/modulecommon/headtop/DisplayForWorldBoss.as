package modulecommon.headtop 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.worldbossCmd.stBossInfo;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	/**
	 * ...
	 * @author ...
	 * 世界BOSS之十面埋伏中，boss头顶显示
	 */
	public class DisplayForWorldBoss 
	{
		private var m_gkContext:GkContext;
		private var m_headTop:HeadTopNpcStateBase;
		private var m_objPanel:ObjectPanel;
		private var m_bossID:uint;
		private var m_bossInfo:stBossInfo;
		private var m_npc:NpcVisit;
		
		public function DisplayForWorldBoss(head:HeadTopNpcStateBase, id:uint) 
		{
			m_headTop = head;
			m_bossID = id;
			m_gkContext = head.gkContext;
			m_npc = m_headTop.npc;
		}
		
		public function update():void
		{
			var str:String;
			if (m_gkContext.m_worldBossMgr.m_bInWBoss)
			{
				m_bossInfo = m_gkContext.m_worldBossMgr.getBossInfoByID(m_bossID);
				if (m_bossInfo)
				{
					str = (m_bossInfo.killNum + 1) + "级 " + m_npc.name;
				}
			}
			else if (m_gkContext.m_elitebarrierMgr.m_bInJBoss)
			{
				m_bossInfo = m_gkContext.m_elitebarrierMgr.getBossInfoByID();
				if (m_bossInfo)
				{
					str = m_npc.npcBase.m_name;
				}
			}
			
			m_headTop.clearAutoData();
			m_headTop.addAutoData(str, 0xfff000, 14);
			
			showRewardObj();
		}
		
		private function showRewardObj():void
		{
			if (null == m_objPanel)
			{
				m_objPanel = new ObjectPanel(m_gkContext, m_headTop, -22, -70);
				m_objPanel.setPanelImageSkin(ZObject.IconBg);
				m_objPanel.showObjectTip = true;
			}
			
			if (m_bossInfo)
			{
				var obj:ZObject = ZObject.createClientObject(m_bossInfo.killreward.objID, m_bossInfo.killreward.num);
				if (obj)
				{
					m_objPanel.objectIcon.setZObject(obj);
				}
			}
		}
		
		public function dispose():void
		{
			if (m_objPanel)
			{
				if (m_objPanel.parent)
				{
					m_objPanel.parent.removeChild(m_objPanel);
				}
				m_objPanel.dispose();
				m_objPanel = null;
			}
			
		}
	}

}