package modulecommon.scene.beings
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import common.Context;
	
	import modulecommon.GkContext;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * @brief npc 玩家管理器
	 */
	public class PlayerManager implements ITickedObject
	{
		protected var m_context:Context;   
		protected var m_hero:PlayerMain; // 主角    		
		public var m_curPlayers:BeingEntityScene; // 当前场景玩家
		protected var m_gkContext:GkContext;
		//protected var m_plLoaded:int;		// 0  未加载  1 开始加载 2 加载完成    占位资源是否加载完成
		protected var m_pathlist:Vector.<String>;
		protected var m_pathModelCfglist:Vector.<String>;
		protected var m_pathEffCfglist:Vector.<String>;
		public function PlayerManager(gk:GkContext)
		{
			m_gkContext = gk; 
			m_context = m_gkContext.m_context;
			
			m_curPlayers = new BeingEntityScene();
			m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityScenePlayer);
			m_pathlist = new Vector.<String>();
			m_pathModelCfglist = new Vector.<String>();
			m_pathEffCfglist = new Vector.<String>();
		}
		
		public function init():void
		{
		
		}
		
		public function dispose():void
		{
			m_context.m_processManager.removeTickedObject(this);			
		}
		
		// 每一帧都更新      
		public function onTick(deltaTime:Number):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_context.m_sceneView.isLoading)
			{
				return;
			}
			
			var abeing:Player
			for each (abeing in m_curPlayers.m_beingList)
			{
				// 如果可视就更新，如果不可视，就不更新   
				if (abeing.needUpdate())
				{
					abeing.onTick(deltaTime);
				}
			}
			
			// 如果官职竞技中有人就更新
			/*
			if(m_gkContext.m_arenaMgr.m_playerList.length)
			{
				for each(abeing in m_gkContext.m_arenaMgr.m_playerList)
				{
					abeing.onTick(deltaTime);
				}
			}
			*/
		}
		 
		public function get hero():PlayerMain
		{
			/*if (m_hero == null || m_hero.scene == null)
			{
				return null;
			}*/
			return m_hero;
		}
		
		// 直接返回主角数据,不做场景判断
		public function get heroDirect():PlayerMain
		{
			return m_hero;
		}
 
		public function set hero(value:PlayerMain):void
		{
			m_hero = value;
			// 主角属性，在上层自己赋值别忘记了       
			//m_hero.prop = m_context.m_beingProp as BeingProp;
		}		

		public function getBeingByTmpID(tmpid:uint):BeingEntity
		{
			return m_curPlayers.m_tmpid2BeingDic[tmpid];
		}
		
		public function getBeingByName(name:String):BeingEntity
		{
			var ret:BeingEntity;
			for each(ret in m_curPlayers.m_beingList)
			{
				if (ret.name == name)
				{
					return ret;
				}
			}
			return null;
		}
		
		public function setPlayerMainNewTempID(newTempid:uint):void
		{
			if (m_hero == null)
			{
				return;
			}
			if (m_hero.tempid == newTempid)
			{
				return;
			}
			delete m_curPlayers.m_tmpid2BeingDic[m_hero.tempid];
			m_hero.tempid = newTempid;
			m_curPlayers.m_tmpid2BeingDic[m_hero.tempid] = m_hero;
		}
		public function destroyBeingByTmpID(tmpid:uint, bRemove:Boolean = true):void
		{
			try
			{
			var player:Player;
			player = m_curPlayers.m_tmpid2BeingDic[tmpid];
			if (player == null)
			{
				return;
			}
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID 1");
			}
			
			try
			{
			// 逻辑释放保存的指针
			if (m_gkContext.m_sceneLogic)
			{
				m_gkContext.m_sceneLogic.disposeElement(player);
			}
			else
			{
				DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID m_sceneLogic=null");
			}
			}
			
			catch (e:Error)
			{
				DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID 2");
			}
			
			try
			{
			if (bRemove == true)
			{
				var serverScene:fScene = m_context.m_sceneView.scene();
				if (serverScene)
				{
					try
					{
						serverScene.removeCharacter(player);
					}
					catch (e:Error)
					{
						DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID removeCharacter"+e.getStackTrace());
					}
				}
				else
				{
					DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID serverScene=null");
				}
				
			}
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID 3");
			}
			
			try
			{
			var idx:int = m_curPlayers.m_beingList.indexOf(player);
			if (idx >= 0)
			{
				m_curPlayers.m_beingList.splice(idx, 1);
			}
			
			m_curPlayers.m_tmpid2BeingDic[tmpid] = null;
			delete m_curPlayers.m_tmpid2BeingDic[tmpid];
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("PlayerManager::destroyBeingByTmpID 4");
			}
		}

		public function addBeingByTmpID(tmpid:uint, being:BeingEntity):void
		{
			var player:Player;
			player = m_curPlayers.m_tmpid2BeingDic[tmpid];
			if (player != null)
			{
				return;
			}
			player = being as Player;
			m_curPlayers.m_tmpid2BeingDic[tmpid] = player;
			m_curPlayers.m_beingList.push(player);
		}
		
		// 过场景之前初始化   bdispose : 是否将人物释放     
		public function preInit(oldScene:fScene, destroyRender:Boolean = true, bdispose:Boolean = false):void
		{			
			if (m_hero == null)
			{
				return;
			}
			
			var idx:int = m_curPlayers.m_beingList.indexOf(m_hero);
			if (idx >= 0)
			{
				m_curPlayers.m_beingList.splice(idx, 1);
			}
			m_hero.beforeRemoveFromScene();
			oldScene.removeCharacter(m_hero, false);
			// 逻辑释放保存的指针
			m_gkContext.m_sceneLogic.disposeElement(m_hero);
			
			var i:int;
			var size:int = m_curPlayers.m_beingList.length;
			for (i = 0; i < size; i++)
			{
				oldScene.removeCharacter(m_curPlayers.m_beingList[i], true);
				// 逻辑释放保存的指针
				m_gkContext.m_sceneLogic.disposeElement(m_curPlayers.m_beingList[i]);
			}
			m_curPlayers.m_beingList.length = 0;
			m_curPlayers.m_tmpid2BeingDic = new Dictionary();		
			addBeingByTmpID(m_hero.tempid, m_hero);	
		}
		
		// 场景加载完后进行初始化
		public function postInit(newScene:fScene):void
		{
			if (m_hero == null)
			{
				return;
			}
			newScene.addCharacter(m_hero);
			// bug：因为 fFlash9ObjectSeqRenderer 重新生成，因此需要更新一次
			m_hero.updateNameDesc();
			m_hero.afterAddToScene();
		}
		
		// 加载不卸载的资源,只加载主角的资源,
		public function loadResNUnload():void
		{
			//m_plLoaded = 1;
			var idx:int = 0;
			m_pathlist.length = 0;
			m_gkContext.m_delayLoader.m_heroLoaded = true;
			
			var path:String = "";
			var modelstr:String;
			var modellst:Vector.<String> = new Vector.<String>();	// 模型列表
			var joblist:Vector.<uint> = new Vector.<uint>();	// 职业列表
			//joblist.push(PlayerResMgr.JOB_MENGJIANG);
			//joblist.push(PlayerResMgr.JOB_JUNSHI);
			//joblist.push(PlayerResMgr.JOB_GONGJIANG);
			
			var genderlist:Vector.<uint> = new Vector.<uint>();	// 性别列表
			//genderlist.push(PlayerResMgr.GENDER_male);
			//genderlist.push(PlayerResMgr.GENDER_female);
			
			var mainUser:PlayerMain = m_gkContext.m_playerManager.hero;
			if(mainUser)
			{
				joblist.push(mainUser.job);
				genderlist.push(mainUser.gender);
			}
			
			var actlist:Vector.<uint> = new Vector.<uint>();		// 动作列表
			actlist.push(0);
			actlist.push(2);
			actlist.push(7);
			actlist.push(8);
			actlist.push(9);
			
			var dirlist:Vector.<uint> = new Vector.<uint>();	// 方向列表
			dirlist.push(0);
			dirlist.push(1);
			dirlist.push(2);
			dirlist.push(3);
			dirlist.push(7);

			var job:uint;
			var gender:uint;
			var model:String;
			var act:uint;
			var dir:uint;

			for each(job in joblist)
			{
				for each(gender in genderlist)
				{
					modelstr = fUtil.insStrFromModelStr(m_gkContext.m_context.m_playerResMgr.modelName(job, gender));
					
					for each(act in actlist)
					{
						for each(dir in dirlist)
						{
							// 加载图片资源
							path = modelstr + "_" + act + "_" + dir + ".swf";
							// c131_9_7 这个资源是没有的,因此不加载了
							if(!fUtil.isEmptyRes(path))
							{
								path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
								//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
								if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
								{
									//m_gkContext.progLoadingaddResName(path);
									//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
									
									idx = m_pathlist.indexOf(path);
									if(idx == -1)
									{
										m_pathlist.push(path);
										//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
										//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
										
										m_gkContext.progLoadingaddResName(path);
										m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
									}
								}
							}
						}
					}

					// 加载配置文件
					path = "x" + modelstr + ".swf";
					path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
					//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
					if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
					{
						//m_gkContext.progLoadingaddResName(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
						
						idx = m_pathlist.indexOf(path);
						if(idx == -1)
						{
							m_pathlist.push(path);
							//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
							//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
							
							m_gkContext.progLoadingaddResName(path);
							m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
						}
					}
				}
			}
			
			joblist.length = 0;
			genderlist.length = 0;
			actlist.length = 0;
			modellst.length = 0;
			dirlist.length = 0;
			
			// 第一次创建角色
			modellst.push("c17");
			
			actlist.push(0);
			actlist.push(7);

			dirlist.push(0);
			dirlist.push(1);
			dirlist.push(2);
			dirlist.push(3);
			dirlist.push(7);
			
			for each(model in modellst)
			{
				modelstr = model;
				
				for each(act in actlist)
				{
					for each(dir in dirlist)
					{
						// 加载图片资源
						path = modelstr + "_" + act + "_" + dir + ".swf";
						// c131_9_7 这个资源是没有的,因此不加载了
						if(!fUtil.isEmptyRes(path))
						{
							path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
							if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								//m_gkContext.progLoadingaddResName(path);
								//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
								
								idx = m_pathlist.indexOf(path);
								if(idx == -1)
								{
									m_pathlist.push(path);
									//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
									//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
									
									m_gkContext.progLoadingaddResName(path);
									m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
								}
							}
						}
					}
				}
				
				// 加载配置文件
				path = "x" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
				//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{
					//m_gkContext.progLoadingaddResName(path);
					//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					
					idx = m_pathlist.indexOf(path);
					if(idx == -1)
					{
						m_pathlist.push(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						
						m_gkContext.progLoadingaddResName(path);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					}
				}
			}
			
			// 又一个特殊处理
			joblist.length = 0;
			genderlist.length = 0;
			actlist.length = 0;
			modellst.length = 0;
			dirlist.length = 0;
			
			// 第一次创建角色
			modellst.push("c201");
			
			actlist.push(0);
			
			dirlist.push(1);
			
			for each(model in modellst)
			{
				modelstr = model;
				
				for each(act in actlist)
				{
					for each(dir in dirlist)
					{
						// 加载图片资源
						path = modelstr + "_" + act + "_" + dir + ".swf";
						// c131_9_7 这个资源是没有的,因此不加载了
						if(!fUtil.isEmptyRes(path))
						{
							path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
							if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								//m_gkContext.progLoadingaddResName(path);
								//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
								
								idx = m_pathlist.indexOf(path);
								if(idx == -1)
								{
									m_pathlist.push(path);
									//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
									//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
									
									m_gkContext.progLoadingaddResName(path);
									m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
								}
							}
						}
					}
				}
				
				// 加载配置文件
				path = "x" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
				//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{
					//m_gkContext.progLoadingaddResName(path);
					//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					
					idx = m_pathlist.indexOf(path);
					if(idx == -1)
					{
						m_pathlist.push(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						//m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedNoProgSWF, onFailedNoProgSWF);
						
						m_gkContext.progLoadingaddResName(path);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
					}
				}
			}
			
			if(m_pathlist.length == 0)
			{
				//m_gkContext.progResLoaded("beingLoadend");
			}
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
			m_gkContext.m_context.progLoading.progResLoaded(event.resourceObject.filename);
			
			// 一定要放在某一个资源加载完成后再完成占位资源，不要在其它地方完成占位资源
			//if(1 == m_plLoaded)
			//{
			//	m_plLoaded = 2;
			//	onloadedPlaceholderSWF();
			//}
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
			m_gkContext.m_context.progLoading.progResFailed(event.resourceObject.filename);
		}
		
		private function onProgressSWF(event:ResourceProgressEvent):void
		{
			m_gkContext.progResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStartedSWF(event:ResourceEvent):void
		{
			m_gkContext.progResStarted(event.resourceObject.filename);
		}
		
		// 判断角色的包是否有资源包
		//public function isEmptyRes(path:String):Boolean
		//{
		//	if(path == "c131_9_7.swf" || 
		//	   path == "c131_9_3.swf" || 
		//	   path == "c131_9_2.swf" || 
		//	   path == "c131_9_1.swf" || 
		//	   path == "c131_9_0.swf" || 
		//	   path == "c112_9_7.swf" || 
		//	   path == "c112_9_3.swf" ||
		//	   path == "c112_9_2.swf" ||
		//	   path == "c112_9_1.swf" ||
		//	   path == "c112_9_0.swf" ||
		//	   path == "c111_7_0.swf" ||
		//	   path == "c111_7_2.swf" ||
		//	   path == "c111_7_3.swf" ||
		//	   path == "c111_7_7.swf"
		//	  )
		//	{
		//		return true;
		//	}
		//	
		//	return false;
		//}
		
		// 只有第一次进入游戏的时候才会加载
		public function load1000SceneRes():void
		{
			var path:String = "";
			var modelstr:String = "c213";
			path = modelstr + "_" + "0" + "_" + "1" + ".swf";
			path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
			//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
			if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
			{
				m_gkContext.progLoadingaddResName(path);
				//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
				m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
			}

			// 加载配置文件
			path = "x" + modelstr + ".swf";
			path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
			//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
			if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
			{
				m_gkContext.progLoadingaddResName(path);
				//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
				m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF);
			}
		}
		
		// 加载占位资源,使进度条好看一点
		public function loadPlaceholder():void
		{
			/*
			var total:int = 30;
			var cur:int;
			var phpre:String = "placeholder";
			var path:String;
			while(cur < total)
			{
				path = phpre + "_" + cur + ".swf"
				m_gkContext.progLoadingaddResName(path);
				++cur;
			}
			*/
			
			//m_gkContext.progLoadingaddResName("beingLoadend");
			//m_gkContext.progLoadingaddResName("wubeingLoadend");
			
			//m_gkContext.progLoadingaddResName("modelcfgLoadend");
			//m_gkContext.progLoadingaddResName("effcfgLoadend");
		}
		
		// 占位资源加载完成
		public function onloadedPlaceholderSWF():void
		{
			var total:int = 30;
			var cur:int;
			var phpre:String = "placeholder";
			var path:String;
			while(cur < total)
			{
				path = phpre + "_" + cur + ".swf"
				m_gkContext.m_context.progLoading.progResLoaded(path);
				++cur;
			}
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedNoProgSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if(m_pathlist.length == 0)
				{
					//m_gkContext.progResLoaded("beingLoadend");
				}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedNoProgSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedNoProgSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
			
			// 加载进度条
			var idx:int = m_pathlist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathlist.splice(idx, 1);
				if(m_pathlist.length == 0)
				{
					//m_gkContext.progResLoaded("beingLoadend");
				}
			}
		}
		
		// 加载所有的模型的配置文件
		public function loadModelCfg():void
		{
			m_pathModelCfglist.length = 0;
			
			var path:String = "";
			var modelstr:String = "";
			var idx:int = 0;
			var namelst:Array = [11,111,112,12,121,122,13,131,132,14,15,16,17,18,19,20,201,202,203,204,205,206,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,234,235,237,238,239,24,240,241,242,25,26,27,28,29,30,301,302,303,304,305,306,307,308,309,31,310,311,313,314,32,33,34,35,36,37,38,39,40,401,41,42,43,44,45,46,47,48,49,50,51];
			var nameidx:int = 0;

			while(nameidx < namelst.length)
			{
				modelstr = namelst[nameidx];
				path = "xc" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
				//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{
					idx = m_pathModelCfglist.indexOf(path);
					if(idx == -1)
					{
						m_pathModelCfglist.push(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedModelCfgNoProgSWF, onFailedModelCfgNoProgSWF);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedModelCfgNoProgSWF, onFailedModelCfgNoProgSWF);
					}
				}
				
				++nameidx;
			}
			
			if(m_pathModelCfglist.length == 0)
			{
				m_gkContext.progResLoaded("modelcfgLoadend");
			}
		}

		// 加载所欲特效的配置文件
		public function loadEffCfg():void
		{
			m_pathEffCfglist.length = 0;
			
			var path:String = "";
			var modelstr:String = "";
			var idx:int = 0;
			var namelst:Array = [402,11111,11112,1112,11121,11211,11212,11213,1122,11221,11222,11290,1211,12111,12112,12113,1212,12131,12132,12133,12134,12135,12136,12137,12138,12139,12140,12141,12142,12143,12144,12151,12161,12171,12211,12212,12214,1311,1312,1314,13211,13212,1324,1412,1413,1423,1433,1511,15,2,1611,1612,1614,1621,1711,1714,1721,1724,1731,1811,1812,1813,1822,1823,1911,1912,1914,1921,2012,2022,2032,2042,2111,2112,2211,2212,2222,2311,2411,2412,2422,2511,2512,2521,2522,2611,2612,2614,2624,2711,2712,2811,2821,30111,30112,3012,3013,30211,3023,30312,30322,30421,30422,3,423,30511,30512,30521,30612,30713,30811,30913,30914,30923,30924,3112,31212,31312,3211,3212,3221,3222,3311,3313,3611,3612,3614,401,4010,402,403,4111,4113,4611,4612,4712,501,502,503,504,505,506,999011,999012,999021,999022,999023,999024,999031,999032,999033,999034,999041,999042,999043,999044,999051,999052,999053,999054,999061,999062,999063,999064,9990711,999081,999082,999083,999084,999091,999092,999093,999094,999101,999102,999,03,999104,999111,999112,999113,999114,999121,999122,999123,999124,99921];
			var nameidx:int = 0;
			
			while(nameidx < namelst.length)
			{
				modelstr = namelst[nameidx];
				path = "xe" + modelstr + ".swf";
				path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLEINS);
				//if (!m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource)) // 如果资源没有加载
				if (!m_gkContext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				{
					idx = m_pathEffCfglist.indexOf(path);
					if(idx == -1)
					{
						m_pathEffCfglist.push(path);
						//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedEffCfgNoProgSWF, onFailedEffCfgNoProgSWF);
						m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedEffCfgNoProgSWF, onFailedEffCfgNoProgSWF);
					}
				}
				
				++nameidx;
			}
			
			if(m_pathEffCfglist.length == 0)
			{
				m_gkContext.progResLoaded("effcfgLoadend");
			}
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedModelCfgNoProgSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			var insID:String;
			var insdef:fObjectDefinition;
			insID = fUtil.getInsIDByPath(event.resourceObject.filename);
			insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
			// 检查一遍是否被其它地方填充了这个定义 
			if (!insdef)
			{
				// 直接解析 xml 
				var bytes:ByteArray;
				var clase:String = fUtil.xmlResClase(event.resourceObject.filename);
				bytes = (event.resourceObject as SWFResource).getExportedAsset(clase) as ByteArray;
				
				var xml:XML;
				xml = new XML(bytes.readUTFBytes(bytes.length));
				
				// 不再拷贝
				//insdef = new fObjectDefinition(xml.copy(), event.resourceObject.filename);
				insdef = new fObjectDefinition(xml, event.resourceObject.filename);
				xml = null;
				if (insdef)
				{
					this.m_gkContext.m_context.m_sceneResMgr.addInsDefinition(insdef);
				}
			}
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)

			var idx:int = m_pathModelCfglist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathModelCfglist.splice(idx, 1);
				if(m_pathModelCfglist.length == 0)
				{
					m_gkContext.progResLoaded("modelcfgLoadend");
				}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedModelCfgNoProgSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedNoProgSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
			
			// 加载进度条
			var idx:int = m_pathModelCfglist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathModelCfglist.splice(idx, 1);
				if(m_pathModelCfglist.length == 0)
				{
					m_gkContext.progResLoaded("modelcfgLoadend");
				}
			}
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedEffCfgNoProgSWF(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			var insID:String;
			var insdef:fObjectDefinition;
			insID = fUtil.getInsIDByPath(event.resourceObject.filename);
			insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
			// 检查一遍是否被其它地方填充了这个定义 
			if (!insdef)
			{
				// 直接解析 xml 
				var bytes:ByteArray;
				var clase:String = fUtil.xmlResClase(event.resourceObject.filename);
				bytes = (event.resourceObject as SWFResource).getExportedAsset(clase) as ByteArray;
				
				var xml:XML;
				xml = new XML(bytes.readUTFBytes(bytes.length));
				
				// 不再拷贝
				//insdef = new fObjectDefinition(xml.copy(), event.resourceObject.filename);
				insdef = new fObjectDefinition(xml, event.resourceObject.filename);
				xml = null;
				if (insdef)
				{
					this.m_gkContext.m_context.m_sceneResMgr.addInsDefinition(insdef);
				}
			}
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)

			var idx:int = m_pathEffCfglist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathEffCfglist.splice(idx, 1);
				if(m_pathEffCfglist.length == 0)
				{
					m_gkContext.progResLoaded("effcfgLoadend");
				}
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedEffCfgNoProgSWF(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedNoProgSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
			
			// 加载进度条
			var idx:int = m_pathEffCfglist.indexOf(event.resourceObject.filename);
			if(idx >= 0)
			{
				m_pathEffCfglist.splice(idx, 1);
				if(m_pathEffCfglist.length == 0)
				{
					m_gkContext.progResLoaded("effcfgLoadend");
				}
			}
		}
		
		// 将打包的模型配置文件一次加载进入内存
		public function loadModelCfgOnlyOne():void
		{			
			var path:String = "";
			var modelstr:String = "allbeingxml";
			
			path = "xc" + modelstr + ".swf";
			path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
			//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedModelCfgNoProgSWFOnlyOnce, onFailedModelCfgNoProgSWFOnlyOnce);
			m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedModelCfgNoProgSWFOnlyOnce, onFailedModelCfgNoProgSWFOnlyOnce);
		}
		
		// 将打包的特效配置文件一次加载进入内存
		public function loadEffCfgOnlyOne():void
		{
			var path:String = "";
			var modelstr:String = "alleffectxml";
			
			path = "xe" + modelstr + ".swf";
			path = m_gkContext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLEINS);
			//m_gkContext.m_context.m_resMgrNoProg.load(path, SWFResource, onloadedEffCfgNoProgSWFOnlyOnce, onFailedEffCfgNoProgSWFOnlyOnce);
			m_gkContext.m_context.m_resMgr.load(path, SWFResource, onloadedEffCfgNoProgSWFOnlyOnce, onFailedEffCfgNoProgSWFOnlyOnce);
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedModelCfgNoProgSWFOnlyOnce(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			var allreslst:Array;
			var bytes:ByteArray;
			var clase:String;
			var strlst:String
			
			// 获取所有的资源列表
			bytes = (event.resourceObject as SWFResource).getExportedAsset("art.beingcfg.xcall") as ByteArray;
			strlst = bytes.readUTFBytes(bytes.bytesAvailable);
			allreslst = strlst.split("\r\n");
			
			// 读取所有的列表资源
			var insID:String;
			var insdef:fObjectDefinition;
			var idx:int = 0;
			while(idx < allreslst.length)
			{
				insID = 'c' + allreslst[idx];
				insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
				// 检查一遍是否被其它地方填充了这个定义 
				if (!insdef)
				{
					// 直接解析 xml 
					clase = "art.beingcfg.xc" + allreslst[idx];
					bytes = (event.resourceObject as SWFResource).getExportedAsset(clase) as ByteArray;
					
					var xml:XML;
					xml = new XML(bytes.readUTFBytes(bytes.length));
					
					// 不再拷贝
					//insdef = new fObjectDefinition(xml.copy(), event.resourceObject.filename);
					insdef = new fObjectDefinition(xml, event.resourceObject.filename);
					xml = null;
					if (insdef)
					{
						this.m_gkContext.m_context.m_sceneResMgr.addInsDefinition(insdef);
					}
				}
				
				++idx;
			}
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedModelCfgNoProgSWFOnlyOnce(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedNoProgSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedEffCfgNoProgSWFOnlyOnce(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			
			var allreslst:Array;
			var bytes:ByteArray;
			var clase:String;
			var strlst:String
			
			// 获取所有的资源列表
			bytes = (event.resourceObject as SWFResource).getExportedAsset("art.effectcfg.xeall") as ByteArray;
			strlst = bytes.readUTFBytes(bytes.bytesAvailable);
			allreslst = strlst.split("\r\n");
			
			// 读取所有的列表资源
			var insID:String;
			var insdef:fObjectDefinition;
			var idx:int = 0;
			while(idx < allreslst.length)
			{
				insID = 'e' + allreslst[idx];
				insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
				// 检查一遍是否被其它地方填充了这个定义 
				if (!insdef)
				{
					// 直接解析 xml 
					clase = "art.effectcfg.xe" + allreslst[idx];
					bytes = (event.resourceObject as SWFResource).getExportedAsset(clase) as ByteArray;
					
					var xml:XML;
					xml = new XML(bytes.readUTFBytes(bytes.length));
					
					// 不再拷贝
					//insdef = new fObjectDefinition(xml.copy(), event.resourceObject.filename);
					insdef = new fObjectDefinition(xml, event.resourceObject.filename);
					xml = null;
					if (insdef)
					{
						this.m_gkContext.m_context.m_sceneResMgr.addInsDefinition(insdef);
					}
				}
				
				++idx;
			}
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedEffCfgNoProgSWFOnlyOnce(event:ResourceEvent):void
		{
			Logger.error(null, null, "failed " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedNoProgSWF);
			
			//m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource)
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource)
		}
		
		public function toggleSceneShow(bshow:Boolean):void
		{
			var abeing:Player
			for each (abeing in m_curPlayers.m_beingList)
			{
				if (!(abeing is PlayerMain))
				{
					abeing.toggleSceneShow(bshow);
				}
			}
		}
	}
}