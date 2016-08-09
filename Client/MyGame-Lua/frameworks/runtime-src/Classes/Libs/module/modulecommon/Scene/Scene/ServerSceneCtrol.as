package modulecommon.scene.scene
{
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.TerrainEntity;
	
	import flash.geom.Point;
	
	import modulecommon.GkContext;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.SceneViewer;
	import modulecommon.scene.arena.ArenaMgr;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TGroundObjectItem;
	import modulecommon.scene.prop.table.TMapItem;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICorpsCitySys;
	
	import org.ffilmation.engine.core.fEngine;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fProcessEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ServerSceneCtrol extends SceneCtrolBase
	{
		public function ServerSceneCtrol(gk:GkContext, engine:fEngine, sceneViewer:SceneViewer)
		{
			super(gk, engine, sceneViewer, EntityCValue.SCGAME);
		}
		
		public function gotoScene(path:String, sceneid:uint):void
		{
			m_gkContext.m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			
			if (m_scene && m_scene.m_path == path)
			{
				preGotoScene(false);
				postGotoScene();
				return;
			}			
			// 设置场景状态    
			m_sceneState = EntityCValue.SSIniting;
			
			if (m_scene)
			{
				var bDispose:Boolean = isDisposeScene(m_scene);
				preGotoScene(bDispose);
				//stopFollowHero(m_gkcontext.m_playerManager.heroDirect);	// hero 这个函数做判断会返回 null
				m_camera.stopFollowing(m_gkContext.m_playerManager.heroDirect);
				if (m_scene.m_sceneConfig.fogOpened)
				{
					m_scene.fogPlane.stopFollowing(m_camera);
				}
				
				if (bDispose)
				{
					desposeScene(m_scene);
				}
				else
				{
					this.m_engine.hideScene(m_scene, true);
				}
			}
			
			switchToScene(path, sceneid);
			
			if (m_sceneState == EntityCValue.SSRead)
			{
				if (m_sceneViewer.curSceneType == this.sceneType)
				{
					activateScene();
				}
				postGotoScene();
			}
		}
		
		override public function loadCompleteHandler(evt:fProcessEvent):void
		{
			super.loadCompleteHandler(evt);
			if (m_sceneViewer.curSceneType == this.sceneType)
			{
				activateScene();
			}
			postGotoScene();
			loadSomeInMap();
			
			if(m_gkContext.m_context.m_bFirstCreateAndEnter)		// 如果是第一次创建角色进入场景，就显示 CG 动画
			{
				m_gkContext.m_context.m_bFirstCreateAndEnter = false;
				//m_gkContext.m_UIMgr.showFormEx(UIFormID.UICGIntro);				
			}
		}
		
		private function isDisposeScene(scene:fScene):Boolean
		{
			return true;
		}
		
		protected function preGotoScene(bdispose:Boolean):void
		{
			if (m_scene)
			{
				m_gkContext.m_context.m_terrainManager.preInit(m_scene, true, bdispose);
				
				m_gkContext.m_playerManager.preInit(m_scene, true, true);
				m_gkContext.m_playerFakeMgr.preInit(m_scene, true, true);
				m_gkContext.m_npcManager.preInit(m_scene, true, true);
				m_gkContext.m_fobjManager.preInit(m_scene);
				m_gkContext.m_uiMapSwitchEffect.leaveMap();				
			}
		}
		
		protected function postGotoScene():void
		{
			m_gkContext.m_context.m_processManager.onResize();
			m_gkContext.m_context.m_terrainManager.postInit(m_scene);
			
			m_gkContext.m_playerManager.postInit(m_scene);
			m_gkContext.m_context.m_gameHandleMsg.unCacheMsg();
			
			var zobj:ZObject = m_gkContext.m_contentBuffer.getContent("uiHintMgr_GetEquip", true) as ZObject;
			if (zobj)
			{
				m_gkContext.m_objMgr.hintOnGetEquip(zobj);
			}
			
			this.m_gkContext.m_uiMapSwitchEffect.enterMap();
			
			
			
			if (m_gkContext.m_screenbtnMgr.isShowUIScreenBtn)
			{
				m_gkContext.m_screenbtnMgr.showUIScreenBtn();
			}
			
			var ui:IUICorpsCitySys;
			if(m_gkContext.m_mapInfo.m_servermapconfigID == MapInfo.MAPID_CORPSCITY)	// 88 是个默认的军团战的地图
			{
				ui = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				if(ui && ui.bReady)
				{
					ui.toggleSceneUI(0);
				}
			}
			else if(m_gkContext.m_mapInfo.mapType() == MapInfo.CorpsCitySys)		// 如果是军团城市争夺战，就显示一个界面,这次需要在地图上建立模型，因此要等到地图加载完成才行
			{
				ui = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				if(ui && ui.bReady)
				{
					//m_gkContext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
					ui.toggleSceneUI(1);
				}
			}
		}
		
		private function loadSomeInMap():void
		{
			if (m_scene.m_sceneConfig.fogOpened)
			{
				var porp:BeingProp = m_gkContext.m_beingProp;
				//this._scene[m_curSceneID].fogPlane.drawParam(porp.m_charScene.m_fogLast.x, porp.m_charScene.m_fogLast.y, 300, 6);
				m_scene.fogPlane.drawParam(porp.m_charScene.m_fogLast.x, porp.m_charScene.m_fogLast.y, 6);
				m_scene.fogPlane.drawFog();
				m_scene.fogPlane.updateFog();
				
				// 测试主角旁边一块区域
				//this._scene[m_curSceneID].fogPlane.drawParamAny(porp.m_charScene.m_fogLast.x + 100, porp.m_charScene.m_fogLast.y + 100, 400);
				//this._scene[m_curSceneID].fogPlane.drawFogAny();
				//this._scene[m_curSceneID].fogPlane.updateFog();		// 更新一个主角所见到的雾，否则不能看到显示
				//this._scene[m_curSceneID].fogPlane.drawFogAny(porp.m_charScene.m_fogLast.x + 100, porp.m_charScene.m_fogLast.y + 100, 400, true);
			}
			
			addGO();
		}
		
		private function addGO():void
		{
			var pt:Point;
			//var go:ThingEntity;
			var goitem:TGroundObjectItem;
			var mapitem:TMapItem;
			var id:uint;
			//var thing:ThingEntity;
			
			mapitem = (this.m_gkContext.m_dataTable.getItemEx(DataTable.TABLE_MAP, this.m_gkContext.m_mapInfo.clientMapID)) as TMapItem;
			if (mapitem)
			{
				id = mapitem.m_goStartID;
				while (id <= mapitem.m_goEndID)
				{
					goitem = (this.m_gkContext.m_dataTable.getItem(DataTable.TABLE_GROUNDOBJECT, id)) as TGroundObjectItem;
					if (goitem)
					{
						var terEnt:TerrainEntity;
						terEnt = m_gkContext.m_context.m_terrainManager.terrainEntityByScene(m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCGAME));
						terEnt.addThingByID(goitem.m_strModel, goitem.m_pos.x, goitem.m_pos.x);
					}
					
					++id;
				}
			}
		}
	}
}