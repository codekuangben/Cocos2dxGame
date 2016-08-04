package game.ui.uiWorldMap 
{
	import com.bit101.components.Component;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.prop.table.TWorldmapItem;
	import modulecommon.uiObject.UIMBeing;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCom extends Component 
	{
		public static const PLAYER_ID:String = "uiWorldMap_main";
		private var m_gkContext:GkContext;
		private var m_player:UIMBeing;
		private var m_curMapItem:TWorldmapItem;
		public function PlayerCom(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		public function initData(curMapItem:TWorldmapItem):void
		{
			if (m_player == null)
			{
				var modelName:String = (m_gkContext.m_playerManager.hero as PlayerMain).modelName();
				m_player = m_gkContext.m_context.m_uiObjMgr.createUIObject(PLAYER_ID, modelName, UIMBeing) as UIMBeing;
				m_player.changeContainerParent(this);
				m_player.setScale(0.7);
			}
			
			m_curMapItem = curMapItem;
			if (curMapItem == null)
			{
				return;
			}
			
			m_player.moveTo(curMapItem.x, curMapItem.y, 0);
		}
		override public function dispose():void 
		{
			super.dispose();
			if (m_player)
			{
				m_player.offawayContainerParent();
				m_gkContext.m_context.m_uiObjMgr.releaseUIObject(m_player);
				//m_gkContext.m_context.m_processManager.addTickedObject(m_player);
				m_player = null;
			}
		}
		
		public function runToPos(destMapItem:TWorldmapItem, funOnArrive:Function):void
		{
			if (destMapItem == m_curMapItem)
			{
				if (m_player.x == destMapItem.x && m_player.y == destMapItem.y)
				{
					funOnArrive();
					return;
				}
			}
			m_curMapItem = destMapItem;
			m_player.funOnarrive = funOnArrive;
			m_player.moveToPos(m_curMapItem.x, m_curMapItem.y);
		}
		public function moveTo(_x:Number, _y:Number):void
		{
			m_player.moveTo(_x, _y, 0);
		}
	}

}