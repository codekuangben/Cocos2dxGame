package app
{
	import app.login.ModuleLoginRoot;
	import base.IStart;
	import com.bit101.components.Component;
	import com.bit101.components.label.Label2;
	import com.dgrigg.image.CommonImageManager;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.core.InputManager;
	import com.pblabs.engine.core.ProcessManager;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.TerrainManager;
	import com.pblabs.engine.ReplaceResSys;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceManager;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.provider.EmbeddedResourceProvider;
	import com.pblabs.engine.resource.provider.FallbackResourceProvider;
	import com.util.PBUtil;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	
	import ui.UIManagerSimple;
	
	
	
	
	//import com.pblabs.engine.resource.provider.IResourceProvider;
	import com.pblabs.sound.SoundManager;
	import com.util.DebugBox;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.text.engine.TextBlock;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import app.data.RegisterClass;
	import app.util.Path;
	
	import art.moduleapp.config;
	//import art.scene.p0;
	//import art.scene.p1;
	
	import common.Context;
	//import common.config.VersionInfo;
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.msg.basemsg.t_NullCmd;
	
		
	import game.IModuleBase;
	import login.PreLoad;
	
	
	import ui.instance.UIProgLoading;
	
	import org.ffilmation.engine.model.fUIObjectMgr;
	
	
	
	
	/**
	 * @brief
	 */
	public class ModuleAppRoot implements ITickedObject
	{
		// 包含类 
		RegisterClass;
		// cfg 资源
		//[Embed(source="../../../../assets/cfg/config.txt",mimeType="application/octet-stream")]
		//protected var m_assetCfg:Class;
		
		public var m_rootSpt:Sprite;
		
		// 记载的模块 
		//private var m_imlogin:IMLogin; 	// 登陆模块 
		//private var m_imgame:IMGame; 	// 游戏模块 
		//private var m_imfight:IMFight; 	// 战斗模块 
		private var m_imVec:Vector.<IModuleBase>;
				
		public var m_context:Context;
		
		public var m_ModuleStart:IStart;
		public var m_ModuleLogin:ModuleLoginRoot;
		private var m_frameSound:Sound;
		
		private var m_preLoaded:Boolean; // true - PreLoad是否执行完毕（其中规定的资源已经加装完了）
		
		public function ModuleAppRoot()
		{
		
		}
		
		public function init(sp:Sprite):void
		{			
			m_imVec = new Vector.<IModuleBase>(EntityCValue.ModuleCnt, true);
			m_rootSpt = sp;
			m_ModuleStart = m_rootSpt.parent as IStart;
			
			m_context = new Context();			
			m_context.m_LoginMgr.msgTick = this;
			DebugBox.m_context = m_context;
			
			
			
			m_ModuleStart.uncaughtErrorHandler = m_context.onUncaughtErrorHappened;
			m_rootSpt.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, m_context.onUncaughtErrorHappened);
			Label2.s_textBlock = new TextBlock();
			// 注册各种类型，底层使用上层的类型注册的地方，就不用 getDefinitionByName 这个获取类了      	     
						
			m_context.mainStage = this.m_rootSpt.stage;
			
			m_context.m_processManager = new ProcessManager(m_context);
			m_context.m_resMgr = new ResourceManager(m_context);
			//(m_context.m_resMgr as ResourceManager).m_RPType = EntityCValue.RP_UI;
			//m_context.m_resMgrNoProg = new ResourceManager(m_context);
			//(m_context.m_resMgrNoProg as ResourceManager).m_RPType = EntityCValue.RP_Scene;
			
			m_context.m_soundMgr = new SoundManager(m_context);
			
			m_context.m_embeddedResourceProvider = new EmbeddedResourceProvider(m_context);
			m_context.m_fallbackResourceProvider = new FallbackResourceProvider(m_context);
			
			//m_context.m_embeddedResourceProvider = new Vector.<IResourceProvider>(EntityCValue.RP_CNT, true);
			//m_context.m_fallbackResourceProvider = new Vector.<IResourceProvider>(EntityCValue.RP_CNT, true);
			
			//m_context.m_embeddedResourceProvider[EntityCValue.RP_UI] = new EmbeddedResourceProvider(m_context);
			//m_context.m_fallbackResourceProvider[EntityCValue.RP_UI] = new FallbackResourceProvider(m_context, "PBEFallbackProvider1f");
			
			//m_context.m_embeddedResourceProvider[EntityCValue.RP_Scene] = new EmbeddedResourceProvider(m_context);
			//m_context.m_fallbackResourceProvider[EntityCValue.RP_Scene] = new FallbackResourceProvider(m_context, "PBEFallbackProvider2f");
			
			//(m_context.m_fallbackResourceProvider[EntityCValue.RP_UI] as FallbackResourceProvider).getloader.maxConnectionsPerHost = 5;	// 场景同时加载 53个
			//(m_context.m_fallbackResourceProvider[EntityCValue.RP_Scene] as FallbackResourceProvider).getloader.maxConnectionsPerHost = 5;	// 场景同时加载 5 个
			m_context.m_processManager.start();
			
			
			m_context.m_processManager.addTickedObject(m_context.m_soundMgr as ITickedObject, EntityCValue.PrioritySound);
			m_context.m_inputManager = new InputManager(m_context);
						
			m_context.m_uiManagerSimple = new UIManagerSimple(m_context);
			
			
			m_context.m_platformMgr.init();
			m_context.m_path = new Path(m_context);
			
			m_context.m_uiObjMgr = new fUIObjectMgr(m_context);
			
			m_context.initNode(m_rootSpt);
			// 上面的初始化完了才能初始化下面的  
			
			m_context.getLay(Context.TLayUI).addChild(m_context.m_uiManagerSimple);
			//m_context.m_unloadLoginFunc = closeModuleLogin;
			
			m_context.m_terrainManager = new TerrainManager(m_context);
			m_context.m_replaceResSys = new ReplaceResSys(m_context);
			// 人物属性 
			//m_context.m_beingProp = new BeingProp();
			
			
			// 效率显示,默认不显示    
			//m_context.m_stats = new Stats();
			//m_context.m_stats.visible = false;
			//m_context.getLay(Context.TLayDebug).addChild(m_context.m_stats);
			
			m_context.m_preLoad = new PreLoad(m_context, this);
			
			// 每一帧都循环   
			m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityMsg);
			m_context.m_commonImageMgr = new CommonImageManager(m_context);
			//(m_context.m_commonImageMgr as EventDispatcher).addEventListener(CommonImageManager.CICEVENT, startEnterLogin);
			
			// 版本文件
			m_context.m_verInfoFun = m_ModuleStart.versionAllInfo.getVersionByFileName;
			m_context.m_version = m_ModuleStart.versionAllInfo.version;
			//m_context.m_verInfo.m_context = m_context;
			/*if (m_rootSpt.parent)
			{
				
				if (m_rootSpt.parent["progResLoaded"])
				{
					m_gkcontext.m_startLoadedCB = m_rootSpt.parent["progResLoaded"] as Function;
				}
				
				if (m_rootSpt.parent["progResProgress"])
				{
					m_gkcontext.m_startLoadingCB = m_rootSpt.parent["progResProgress"] as Function;
				}
				
				if (m_rootSpt.parent["progResFailed"])
				{
					m_gkcontext.m_startFailedCB = m_rootSpt.parent["progResFailed"] as Function;
				}
			}*/
			
			// 延迟加载队列
			
			
			//设置占位资源
			//m_context.m_playerPlace = new p0();
			//m_context.m_thingPlace = new p1();			
			
			// KBEN: 键盘 F11 全屏处理  
			//(m_context.m_inputManager as InputManager).addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			//m_context.mainStage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenCheck);	
			
			// 启动起来设置占据整个屏幕     
			//setToSize("100%","100%");
			// 解析基本配置文件 
			parseCfg();
			m_context.m_path.init(); // 初始化路径信息
			Skin.setCont(m_context);
			Component.setContext(m_context);			
			
			// 显示加载进度条
			m_context.progLoading = new UIProgLoading();
			m_context.m_uiManagerSimple.addForm(m_context.progLoading);
			//m_gkcontext.m_UIs.progLoading.show();
						
			m_ModuleLogin = new ModuleLoginRoot(m_context);
			//根据网上的资料,通过此方式,在失去焦点的情况下,保证帧率正常
			m_frameSound = new Sound(new URLRequest(""));
			m_frameSound.play();
			m_frameSound.close();
		}
		
		public function beginProcess():void
		{
			m_context.m_logContent += m_ModuleStart.getLog();
			m_context.addLog(getTimer() + " beginProcess");
			m_context.progLoading.loadRes();
			m_ModuleLogin.beginLogin();
		
			
			if (false == has_firstLogin())
			{
				m_context.m_preLoad.load();
			}
			else
			{
				m_context.addLog("firstLogin");
			}
		}
		
		private function has_firstLogin():Boolean
		{
			var sharObject:SharedObject = SharedObject.getLocal("firstlogin");
			if (sharObject && sharObject.data.firstlogin != undefined)
			{
				return false;
			}
			try
			{
				sharObject.data.firstlogin = true;
			}
			catch (e:Error)
			{
				var str:String = "保存firstlogin 出问题";
				m_context.addLog(str);
			}
			return true;
		
		}
		
		public function destroy():void
		{
			
		}
		
		public function loadModule(moduleid:uint):void
		{
			var path:String;
			
			path = m_context.m_path.getPathByID(moduleid);
			m_context.m_resMgr.load(path, SWFResource, onModuleLoaded, onModuleFailed, onModuleProgress, onModuleStarted);
		
		}
		
				
		private function onModuleLoaded(event:ResourceEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;			
			var moduleid:uint = m_context.m_path.convPath2ID(res.filename);
			
			Logger.info(this, "onModuleLoaded", res.filename + " loaded");
			m_imVec[moduleid] = res.content as IModuleBase;
			// 设置参数  
			m_imVec[moduleid].context = m_context;
			
			
			// 这个要放在最后，因为 Context 里保存许多全局变量，需要销毁自己模块的全局变量   
			// 初始化数据       
			m_imVec[moduleid].init();
			if (EntityCValue.ModuleGame == moduleid)
			{
				if (m_context.m_preLoad)
				{
					m_context.m_preLoad.setLoad(EntityCValue.PreloadRES_GAME);
				}
				
				// 加载进度条
				m_context.progLoading.progResLoaded(res.filename);
			}
		}
		
		private function onModuleFailed(event:ResourceEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;
			Logger.error(this, "onModuleFailed", res.filename + " failed");
			m_context.m_resMgr.unload(res.filename, SWFResource);
			
			var moduleid:uint = m_context.m_path.convPath2ID(res.filename);
			if (EntityCValue.ModuleGame == moduleid)
			{
				// 加载进度条
				m_context.progLoading.progResFailed(res.filename);
			}
		}
		
		private function onModuleProgress(event:ResourceProgressEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;
			var moduleid:uint = m_context.m_path.convPath2ID(res.filename);
			if (EntityCValue.ModuleGame == moduleid)
			{
				//m_gkcontext.progResProgress(event.resourceObject.filename, event._percentLoaded);
			}
		}
		
		private function onModuleStarted(event:ResourceEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;
			var moduleid:uint = m_context.m_path.convPath2ID(res.filename);
			if (EntityCValue.ModuleGame == moduleid)
			{
				// 加载进度条
				//m_gkcontext.progResStarted(event.resourceObject.filename);
			}
		}
		
		/*public function beginToScene():void
		   {
		   m_gkcontext.m_LoginMgr.setLoginprocessDesc("开始加载Game模块");
		   // 显示加载进度条
		   //m_gkcontext.m_UIs.progLoading.show();
		   m_gkcontext.m_preLoad.load();
		 }*/
		
		public function onPreLoaded():void
		{
			//m_gkcontext.m_LoginMgr.setLoginprocessDesc("成功加载Game模块");
			m_context.m_gkcontext.onPreloaded();
			m_preLoaded = true;
			var msg:ByteArray = m_context.m_contentBuffer.getContent("bufferMsgForGameLoad", true) as ByteArray;
			if (msg)
			{
				var cmd:uint = msg.readUnsignedByte();
				var param:uint = msg.readUnsignedByte();
				msg.position = 0;
				m_context.m_gameHandleMsg.handleMsg(msg, cmd, param);
				m_context.clearMsgBufferFlag(EntityCValue.BufferMsg_forGame);
			}			
		}
		
		/*
		 * 在2钟情况下，会调用此函数
		 * 1. 正常情况下，由ProcessManager调用
		 * 2. Socket被动断开的情况下，由LoginMgr::onworldCloseEvent调用
		 */
		public function onTick(deltaTime:Number):void
		{
			// 设置默认的 stage 焦点, focus = stage
			if (!m_context.m_mainStage.focus)
			{
				m_context.focusStage();
			}
			//var msg:ByteArray = m_context.m_sockMgr.GetMsg();
			//while (msg != null)
			//{
			//Session.handleMsg(msg);
			//
			//msg = m_context.m_sockMgr.GetMsg();
			//}
			// 去消息从自己的 socket 中取，如果 socket 断开后，就取不出消息来了
			// bug 总是去不出消息来，原来这里导致的
			if (!m_context.m_sceneSocket)
			{
				return;
			}
			
			if (m_context.isMsgBuffer)
			{
				return;
			}
			
			var strLog:String;
			var msg:ByteArray = m_context.m_sceneSocket.GetMsg();
			while (msg != null)
			{
				// 输出日志  
				var cmd:uint = msg.readUnsignedByte();
				var param:uint = msg.readUnsignedByte();
				
				if (cmd == 0)
				{
					var nullCmd:t_NullCmd = new t_NullCmd();
					try
					{
						m_context.sendMsg(nullCmd);
					}
					catch (e:Error)
					{
						strLog = "ModuleAppRoot::onTick()" + "t_NullCmd\n" + e.getStackTrace();
						DebugBox.sendToDataBase(strLog);
					}
				}
				else
				{
					if (PBUtil.LOGGEROPEN)
					{
						strLog = "receive msg: cmd=" + cmd + " param=" + param;
						strLog += " name=" + stNullUserCmd.getMsgName(cmd, param);
						Logger.info(null, null, strLog);
					}
					
					if (cmd == 3 && param == 2 && m_context.m_LoginMgr.m_receiveMapMsg == false)
					{
						m_context.m_LoginMgr.m_receiveMapMsg = true;
						m_context.m_LoginMgr.setLoginprocessDesc("开始加载资源");
						m_context.progLoading.hideLogBtn();
						PBUtil.LOGGEROPEN = false;
					}
					
					msg.position = 0;
					// 登陆消息和游戏时间消息都放在登陆模块
					if (cmd > stNullUserCmd.TIME_USERCMD) //stNullUserCmd.LOGON_USERCMD != cmd && stNullUserCmd.TIME_USERCMD != cmd)
					{
						if (m_preLoaded == false)
						{
							m_context.setMsgBufferFlag(EntityCValue.BufferMsg_forGame);
							m_context.m_contentBuffer.addContent("bufferMsgForGameLoad", msg);
							if (m_context.m_preLoad.loadNone)
							{
								m_context.m_preLoad.load();
							}
							return;
						}
						
						try
						{
							m_context.m_gameHandleMsg.handleMsg(msg, cmd, param);
						}
						catch (e:Error)
						{
							strLog = "ModuleAppRoot::onTick()" + "m_gameHandleMsg.handleMsg" + "receive msg: cmd=" + cmd + " param=" + param + " errorID=" + e.errorID + e.getStackTrace();
							DebugBox.sendToDataBase(strLog);
							DebugBox.info(strLog);
						}
					}
					else
					{
						if (m_context.m_loginHandleMsg)
						{
							try
							{
								m_context.m_loginHandleMsg.handleMsg(msg, cmd, param);
							}
							catch (e:Error)
							{
								strLog = "ModuleAppRoot::onTick()" + "m_loginHandleMsg.handleMsg\n" + "receive msg: cmd=" + cmd + " param=" + param + " errorID=" + e.errorID + e.getStackTrace();
								DebugBox.sendToDataBase(strLog);
								DebugBox.info(strLog);
							}
						}
					}
					
					if (m_context.isMsgBuffer)
					{
						return;
					}
				}
				
				// 在消息循环中可能销毁socket ，在 handleLoginSuccess 这个函数中，连接网关的时候，自己主动断开，不再等待服务器那边主动断开了 
				if (m_context.m_sceneSocket)
				{
					msg = m_context.m_sceneSocket.GetMsg();
				}
				else
				{
					msg = null;
				}
			}
		}
			
		
		// KBEN: 浏览器兼容有问题，不要用这个函数   
		//public function setToSize(width:String, height:String, minWidth:String = null, minHeight:String = null, maxWidth:String = null, maxHeight:String = null):void
		//{
		//m_context.m_canvas.width = width;
		//m_context.m_canvas.height = height;
		//m_context.m_canvas.minWidth = minWidth;
		//m_context.m_canvas.minHeight = minHeight;
		//m_context.m_canvas.maxWidth = maxWidth;
		//m_context.m_canvas.maxHeight = maxHeight;
		//}
		
		// F11 全屏设置 
		public function keyPressed(evt:KeyboardEvent):void
		{
			if (evt.keyCode == InputKey.F11.keyCode)
			{
				m_context.m_config.m_fullScreen = !m_context.m_config.m_fullScreen
				
				if (m_context.m_config.m_fullScreen)
				{
					m_context.mainStage.displayState = StageDisplayState.FULL_SCREEN;
					Logger.info(null, null, "keyPressed 进入全屏");
				}
				else
				{
					m_context.mainStage.displayState = StageDisplayState.NORMAL;
					Logger.info(null, null, "keyPressed 退出全屏");
				}
			}
		}
		
		private function fullScreenCheck(e:FullScreenEvent):void
		{
			if (e.fullScreen)
			{
				m_context.m_config.m_fullScreen = true;
				m_context.mainStage.displayState = StageDisplayState.FULL_SCREEN;
				Logger.info(null, null, "fullScreenCheck 进入全屏");
			}
			else
			{
				m_context.m_config.m_fullScreen = false;
				m_context.mainStage.displayState = StageDisplayState.NORMAL;
				Logger.info(null, null, "fullScreenCheck 退出全屏");
			}
		}
		
		// 解析配置文件    
		protected function parseCfg():void
		{
			//var byteData:ByteArray = new m_assetCfg();
			var byteData:ByteArray = new config();
			//var str:String = byteData.readUTF();
			var str:String = byteData.readUTFBytes(byteData.bytesAvailable);
			var key:String = "";
			var value:String = "";
			var bKey:Boolean = true; // 当前是否在解析 key 的状态   
			var char:String = "";
			var k2vDic:Dictionary = new Dictionary(); // 键到值的映射  
			
			var idx:uint = 0;
			// 不要有空格，没有剔除空格  
			//while (byteData.bytesAvailable)
			while (idx < str.length)
			{
				// char = byteData.readUnsignedByte();
				char = str.charAt(idx);
				if (char == "=")
				{
					bKey = false;
					++idx;
					continue;
				}
				else if (char == "\r" || char == "\n")
				{
					if (key != "" && !k2vDic[key])
					{
						k2vDic[key] = value;
					}
					bKey = true;
					key = "";
					value = "";
					++idx;
					continue;
				}
				
				if (bKey)
				{
					key += char;
				}
				else
				{
					value += char;
				}
				
				++idx;
			}
			// 把最后一个读取出来的放进去  
			if (key != "")
			{
				k2vDic[key] = value;
			}
			
			if (k2vDic["ip"])
			{
				m_context.m_config.m_ip = k2vDic["ip"];
			}
			if (k2vDic["port"])
			{
				m_context.m_config.m_port = parseInt(k2vDic["port"]);
			}
			// 网络配置   
			if (k2vDic["net"])
			{
				m_context.m_config.m_single = (parseInt(k2vDic["net"]) == 0);
			}
			if (k2vDic["version"]) // 版本信息
			{
				m_context.m_config.m_version = k2vDic["version"];
			}
			if (k2vDic["maxwidth"])
			{
				m_context.m_config.m_maxWidth = parseInt(k2vDic["maxwidth"]);
			}
			if (k2vDic["maxheight"])
			{
				m_context.m_config.m_maxHidth = parseInt(k2vDic["maxheight"]);
			}
			if (k2vDic["minwidth"])
			{
				m_context.m_config.m_minWidth = parseInt(k2vDic["minwidth"]);
			}
			if (k2vDic["minheight"])
			{
				m_context.m_config.m_minHeight = parseInt(k2vDic["minheight"]);
			}
			
			if (k2vDic["rootpath"])
			{
				m_context.m_config.m_rootPath = k2vDic["rootpath"];
			}
			if (k2vDic["beingtex"])
			{
				m_context.m_config.m_beingTexPath = k2vDic["beingtex"];
			}
			if (k2vDic["tertex"])
			{
				m_context.m_config.m_terTexPath = k2vDic["tertex"];
			}
			if (k2vDic["efftex"])
			{
				m_context.m_config.m_effTexPath = k2vDic["efftex"];
			}
			if (k2vDic["fobjtex"])
			{
				m_context.m_config.m_fobjTexPath = k2vDic["fobjtex"];
			}
			//if (k2vDic["scene"])
			//{
			//	m_gkcontext.m_context.m_config.m_scenePath = k2vDic["scene"];
			//}
			//if (k2vDic["define"])
			//{
			//	m_gkcontext.m_context.m_config.m_sceneDefPath = k2vDic["define"];
			//}
			if (k2vDic["xmlcins"])
			{
				m_context.m_config.m_xmlcins = k2vDic["xmlcins"];
			}
			if (k2vDic["xmlctpl"])
			{
				m_context.m_config.m_xmlctpl = k2vDic["xmlctpl"];
			}
			if (k2vDic["xmleins"])
			{
				m_context.m_config.m_xmleins = k2vDic["xmleins"];
			}
			if (k2vDic["xmletpl"])
			{
				m_context.m_config.m_xmletpl = k2vDic["xmletpl"];
			}
			if (k2vDic["xmltins"])
			{
				m_context.m_config.m_xmltins = k2vDic["xmltins"];
			}
			if (k2vDic["xmlttpl"])
			{
				m_context.m_config.m_xmlttpl = k2vDic["xmlttpl"];
			}
			if (k2vDic["bufficon"])
			{
				m_context.m_config.m_bufficon = k2vDic["bufficon"];
			}
			if (k2vDic["stoppt"])
			{
				m_context.m_config.m_stoppt = k2vDic["stoppt"];
			}
			if (k2vDic["versiontype"])
			{
				m_context.m_config.m_versiontype = parseInt(k2vDic["versiontype"]);
			}
			if (k2vDic["ttb"])
			{
				m_context.m_config.m_ttb = k2vDic["ttb"];
			}
			
			// 设置版本显示 
			//m_gkcontext.m_context.m_stats.key2value("client", m_gkcontext.m_context.m_config.m_version);
			
			// 配置文件信息解析完了后开始调整窗口大小 
			m_context.m_processManager.onResize();
		}
	
		// 移除 Logo
		//public function removeLogo():void
		//{
		//	m_rootSpt.parent.removeChildAt(0);
		//}
	}
}