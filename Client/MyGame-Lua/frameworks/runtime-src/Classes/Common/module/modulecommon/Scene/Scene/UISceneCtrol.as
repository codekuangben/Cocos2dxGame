package modulecommon.scene.scene
{
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.ui.UIFormID;
	//import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.SceneViewer;
	import org.ffilmation.engine.core.fEngine;
	import modulecommon.GkContext;
	//import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fProcessEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UISceneCtrol extends SceneCtrolBase
	{
		
		public function UISceneCtrol(gk:GkContext, engine:fEngine, sceneViewer:SceneViewer)
		{
			super(gk, engine, sceneViewer, EntityCValue.SCUI);
		
		}
		
		public function gotoScene(path:String, sceneid:uint):void
		{
			m_gkContext.m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			
			// 设置场景状态    
			m_sceneState = EntityCValue.SSIniting;
			preGotoScene(true);
			switchToScene(path, sceneid);
			if (m_sceneState == EntityCValue.SSRead)
			{
				activateScene();
				postGotoScene();				
			}
		}
		
		public function leaveScene():void
		{
			m_gkContext.m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			
			if (m_scene == null)
			{
				return;
			}
			m_gkContext.m_context.m_terrainManager.preInit(m_scene, true, true);
			desposeScene(m_scene);
			m_scene = null;
		}
		
		override public function loadCompleteHandler(evt:fProcessEvent):void
		{
			super.loadCompleteHandler(evt);
			activateScene();
			postGotoScene();
		}
		
		protected function preGotoScene(bdispose:Boolean):void
		{
			m_gkContext.m_UIMgr.closeAllFormInDesktop(UIFormID.SecondLayer);
			m_gkContext.m_uiMapSwitchEffect.leaveMap();
		}
		
		protected function postGotoScene():void
		{			
			m_gkContext.m_context.m_processManager.onResize();			
			m_gkContext.m_context.m_terrainManager.postInit(m_scene);
			this.m_gkContext.m_uiMapSwitchEffect.enterMap();
			
			if (m_scene.m_serverSceneID == m_gkContext.m_mapInfo.m_areanSceneID)
			{
				//这时，表明从游戏场景进入竞技场
				m_gkContext.m_arenaMgr.gotoArena();
			}
			else if (m_scene.m_serverSceneID == m_gkContext.m_mapInfo.m_heroRallSceneID)
			{
				m_gkContext.m_heroRallyMgr.onMapLoaded();
			}
		}
	}

}