package com.pblabs.engine.entity 
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.utils.Dictionary;
	
	import common.Context;
	//import common.IGKContext;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * ...
	 * @author 
	 */
	public class TerrainManager implements ITerrainManager, ITickedObject
	{
		// KBEN: 代表一个地形场景
		protected var m_context:Context;
		protected var m_sceneID2TerDic:Dictionary; 		// [id, TerrainEntity]场景 id 到地形的映射
		protected var m_terEntityDic:Dictionary;			//[m_sceneType, TerrainEntity] 这个记录战斗和普通场景
		protected var m_pathlist:Vector.<String>;
		
		public function TerrainManager(context:Context) 
		{
			m_context = context;
			m_terEntityDic = new Dictionary();
			
			// 添加到帧循环中去     
			m_context.m_processManager.addTickedObject(this, EntityCValue.PrioritySceneTerrain);
			m_sceneID2TerDic = new Dictionary();
			
			m_pathlist = new Vector.<String>();
		}
		
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView ==null || m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			if (m_terEntityDic[EntityCValue.SCGAME])
			{
				m_terEntityDic[EntityCValue.SCGAME].onTick(deltaTime);
			}
			if (m_terEntityDic[EntityCValue.SCUI])
			{
				m_terEntityDic[EntityCValue.SCUI].onTick(deltaTime);
			}
			if (m_terEntityDic[EntityCValue.SCFIGHT])
			{
				m_terEntityDic[EntityCValue.SCFIGHT].onTick(deltaTime);
			}
		}
		
		// 获取的是游戏场景还是战斗场景    
		public function terrainEntity(type:uint):TerrainEntity
		{
			return m_terEntityDic[type];
		}
		
		// 根据路径获取当前的场景 
		public function terrainEntityByPath(path:String):TerrainEntity
		{
			var sc:fScene = m_context.m_sceneView.getScene(path);
			return m_sceneID2TerDic[sc.m_serverSceneID];
		}
		
		// 根据场景直接获取当前的地形 
		public function terrainEntityByScene(sc:fScene):TerrainEntity
		{
			return m_sceneID2TerDic[sc.m_serverSceneID];
		}
		
		// 之前的场景路径 path        
		public function preInit(oldScene:fScene, destroyRender:Boolean, bclose:Boolean):void
		{
			if(oldScene == null)
			{
				return;
			}
			
			if(bclose && m_terEntityDic[oldScene.m_sceneType])
			{
				m_sceneID2TerDic[oldScene.m_serverSceneID].disposeAll();
				m_sceneID2TerDic[oldScene.m_serverSceneID] = null;
				delete m_sceneID2TerDic[oldScene.m_serverSceneID];
				//m_terEntityDic[m_context.m_sceneView.curSceneID] = null;
				//delete m_terEntityDic[m_context.m_sceneView.curSceneID];
			}
			m_terEntityDic[oldScene.m_sceneType] = null;
		}
		
		// 加载的场景    
		public function postInit(newScene:fScene):void
		{
			if(m_sceneID2TerDic[newScene.m_serverSceneID])
			{
				m_terEntityDic[newScene.m_sceneType] = m_sceneID2TerDic[newScene.m_serverSceneID]; 
			}
			else
			{
				m_sceneID2TerDic[newScene.m_serverSceneID] = new TerrainEntity();
				m_terEntityDic[newScene.m_sceneType] = m_sceneID2TerDic[newScene.m_serverSceneID];
				m_terEntityDic[newScene.m_sceneType].m_scene = newScene;	// 设置当前场景给地形
			}
		}
		
		// 加载地形配置文件和地形材质和地形 thumb 文件
		public function loadRes(norid:uint, fightid:uint):void
		{
			var idlist:Vector.<uint> = new Vector.<uint>();
			idlist.push(norid);
			if(fightid)
			{
				idlist.push(fightid);
			}
			if(fightid != 9052)	// 将竞技场战斗地图也加载进来
			{
				idlist.push(9052);
			}
			var id:uint;
			
			var namePath:String;
			var filename:String;
			var type:int;
			var res:SWFResource;		// 检查资源是否加载
			
			m_pathlist.length = 0;
			
			for each(id in idlist)
			{
				// 读取地形配置文件
				namePath = m_context.m_path.getPathByName("x" + id + ".swf", EntityCValue.PHXMLTINS);
				//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
				res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
				if(!res)
				{
					//m_pathlist.push(namePath);
					//m_context.m_gkcontext.progLoadingaddResName(namePath);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
					m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
				}
				
				// 读取材质文件
				filename = "xt" + id;
				type = fUtil.xmlResType(filename);
				namePath = this.m_context.m_path.getPathByName(filename + ".swf", type);
				//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
				res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
				if(!res)
				{
					//m_pathlist.push(namePath);
					//m_context.m_gkcontext.progLoadingaddResName(namePath);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
					m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
				}
				
				// 读取 thunmb 
				filename = "ttb" + id;
				type = fUtil.xmlResType(filename);
				namePath = this.m_context.m_path.getPathByName(filename + ".swf", type);
				//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
				res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
				if(!res)
				{
					m_pathlist.push(namePath);
					//m_context.m_gkcontext.progLoadingaddResName(namePath);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
					m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
				}

				// 阻挡点
				filename = "s" + id;
				if(!isEmptyRes(filename))
				{
					type = fUtil.xmlResType(filename);
					namePath = this.m_context.m_path.getPathByName(filename + ".swf", type);
					//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
					res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
					if(!res)
					{
						//m_pathlist.push(namePath);
						//m_context.m_gkcontext.progLoadingaddResName(namePath);
						//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
						//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
						m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
					}
				}
			}
			
			// 加载模型和特效模板
			filename = "xct0";
			type = fUtil.xmlResType(filename);
			namePath = this.m_context.m_path.getPathByName(filename + ".swf", type);
			//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
			res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
			if(!res)
			{
				//m_pathlist.push(namePath);
				//m_context.m_gkcontext.progLoadingaddResName(namePath);
				//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
				//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
				m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
			}
			
			filename = "xet0";
			type = fUtil.xmlResType(filename);
			namePath = this.m_context.m_path.getPathByName(filename + ".swf", type);
			//res = m_context.m_resMgrNoProg.getResource(namePath, SWFResource) as SWFResource;
			res = m_context.m_resMgr.getResource(namePath, SWFResource) as SWFResource;
			if(!res)
			{
				//m_pathlist.push(namePath);
				//m_context.m_gkcontext.progLoadingaddResName(namePath);
				//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
				//m_context.m_resMgrNoProg.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
				m_context.m_resMgr.load(namePath, SWFResource, onloadedSWFNoProg, onFailedSWFNoProg);
			}
			
			// 如果是第一次加载资源
			//if(m_gkcontext.m_UIs.progLoading.isFirst())
			//{
			//m_context.m_gkcontext.progLoadingaddResName("mapend");
			//}
			
			// 场景资源加载完成就开始进入场景流程,不用等所有资源都加载完成后,所有资源都加载完成,进度条才会消失
			//if(m_pathlist.length == 0 && m_context.m_gkcontext.progLoading_isState(EntityCValue.PgFES))	// 只有加载第一个场景的时候才这样做
			//{
			//	m_context.m_enterSceneCB();
			//}
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			// 加载进度条
			m_context.m_gkcontext.progResLoaded(event.resourceObject.filename);
			
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				// 场景资源加载完成就开始进入场景流程,不用等所有资源都加载完成后,所有资源都加载完成,进度条才会消失
				//if(m_pathlist.length == 0 && m_context.m_gkcontext.progLoading_isState(EntityCValue.PgFES_LoadingRes))	// 只有加载第一个场景的时候才这样做
				//{
				//	m_context.m_enterSceneCB();
				//}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			// 加载进度条
			m_context.m_gkcontext.progResFailed(event.resourceObject.filename);
			
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				//if(m_pathlist.length == 0 && m_context.m_gkcontext.progLoading_isState(EntityCValue.PgFES))	// 只有加载第一个场景的时候才这样做
				//{
				//	m_context.m_enterSceneCB();
				//}
			}
		}
		
		private function onProgressSWF(event:ResourceProgressEvent):void
		{
			m_context.m_gkcontext.progResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStartedSWF(event:ResourceEvent):void
		{
			m_context.m_gkcontext.progResStarted(event.resourceObject.filename);
		}
		
		public function onloadedSWFNoProg(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedSWFNoProg(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
		}
		
		public function isEmptyRes(path:String):Boolean
		{
			if(path == "s9042" || 
			   path == "s9043" || 
			   path == "s9044" || 
			   path == "s9045" || 
			   path == "s9046" || 
			   path == "s9047" || 
			   path == "s9048" || 
			   path == "s9049" || 
			   path == "s9052"
			  )
			{
				return true;
			}
			
			return false;
		}
		
		// 只有第一次进入游戏的时候才会加载
		public function load1000SceneRes():void
		{
			loadRes(1000, 0);
		}
	}
}