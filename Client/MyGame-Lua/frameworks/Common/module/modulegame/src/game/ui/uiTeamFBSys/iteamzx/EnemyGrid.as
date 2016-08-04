package game.ui.uiTeamFBSys.iteamzx 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	
	import flash.display.DisplayObjectContainer;
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcVisitItem;
	import modulecommon.uiObject.UIMBeing;
	
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * ...
	 * @author 
	 * 敌方格子
	 */
	public class EnemyGrid extends Component 
	{		
		public static const WIDTH:int = 74;
		public static const HEIGHT:int = 73;
		
		private var m_gkContext:GkContext;
		private var m_npcVisitItem:TNpcVisitItem;
		
		private var m_beingPanel:Panel;
		private var m_being:UIMBeing;
		
		protected var m_TFBSysData:UITFBSysData;

		public function EnemyGrid(parent:DisplayObjectContainer, xPos:int, yPos:int, data:UITFBSysData) 
		{
			super(parent, xPos, yPos);
			m_TFBSysData = data;
			m_gkContext = m_TFBSysData.m_gkcontext;
			this.setSize(WIDTH, HEIGHT);
			
			m_beingPanel = new Panel(this);
			m_beingPanel.setPos(30, 50);
		}
		
		override public function dispose():void 
		{
			if (m_being)
			{
				//m_being.offawayContainerParent();
				//m_gkContext.m_context.m_uiObjMgr.unAttachFromTickMgr(m_being);
				m_gkContext.m_context.m_uiObjMgr.releaseUIObject(m_being);
				m_being = null;
			}
			//m_gkContext.m_context.m_uiObjMgr.releaseAllObjectByPartialName("uiTeamFBZX");
			
			super.dispose();
		}
		
		public function setNpcID(id:int):void
		{			
			if (m_being)
			{
				m_being.offawayContainerParent();
				m_gkContext.m_context.m_uiObjMgr.unAttachFromTickMgr(m_being);
				m_being = null;
			}
			var str:String;
			m_npcVisitItem = (this.m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCVISIT, id)) as TNpcVisitItem;

			m_being = m_gkContext.m_context.m_uiObjMgr.createUIObject( "uiTeamFBZX_npc" + id, m_npcVisitItem.m_strModel, UIMBeing) as UIMBeing;
			m_being.orientation = 180;
			m_being.changeContainerParent(m_beingPanel);
			m_being.name = m_npcVisitItem.m_name;
			//m_being.setBubble(m_npcVisitItem.m_name);
		}
	}
}