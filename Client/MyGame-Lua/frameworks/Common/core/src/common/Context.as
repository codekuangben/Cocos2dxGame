package common 
{	
	import com.bit101.drag.DragResPool;
	import com.dgrigg.image.CommonImageManager;
	import com.dnd.DragManager;
	import com.gamecursor.GameCursor;
	import com.pblabs.engine.idleprocess.IdleTimeProcessMgr;
	import com.pblabs.engine.IReplaceResSys;
	import com.pblabs.engine.core.IInputManager;
	import com.pblabs.engine.core.IProcessManager;
	import com.pblabs.engine.debug.IProfiler;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.debug.Stats;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.INpcBattleMgr;
	import com.pblabs.engine.entity.ITerrainManager;
	import com.pblabs.engine.resource.IResourceManager;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.provider.IResourceProvider;
	import com.pblabs.sound.ISoundManager;
	import com.util.DebugBox;
	import com.util.GlobalObject;
	import com.util.UtilCommon;
	import common.net.msg.basemsg.stNullUserCmd;
	import common.net.msg.basemsg.t_NullCmd;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.utils.getTimer;
	import login.LoginData;
	import login.LoginMgr;
	import login.PlatformMgr;
	import login.PreLoad;
	import net.IGameNetHandle;
	import net.ContentBuffer;
	import net.http.HttpCmdBase;
	import net.http.HttpCom;
	import net.INetHandle;
	import time.TimeMgr;
	import ui.instance.UIProgLoading;
	import ui.UIManagerSimple;
	
	//import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ui.player.PlayerResMgr;
	import common.config.Config;
	//import common.config.VersionInfo;
	import common.crypto.CryptoSys;
	import common.logicinterface.IPath;
	import common.logicinterface.IUIDebugLog;
	import common.scene.ISceneView;
	import common.scene.ShareObjectMgr;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.core.sceneInitialization.fSceneResourceManager;
	import org.ffilmation.engine.helpers.fActDirOff;
	import org.ffilmation.engine.model.fUIObjectMgr;
	import network.IWorldHandler;
	import shader.ShaderMgr;
	
	/**
	 * @brief 上下环境，底层需要用到的全局变量          
	 */
	public class Context 
	{
		public static const TLayScene:uint = 0;		// 场景层 
		public static const TLayUI:uint = 1;		// UI 层 
		public static const TLayDebug:uint = 2;		// 最上层调试层  
		public static const TLayCnt:uint = 3;		// 层数量  
		
		public var m_gkcontext:IGKContext;
		
		public var m_loginHandleMsg:INetHandle; // 处理登陆模块的消息  
		public var m_gameHandleMsg:IGameNetHandle; // 处理游戏模块的消息
		
		public var m_uiManagerSimple:UIManagerSimple;
		public var m_resMgr:IResourceManager;			// 显示加载进度的从这个加载
		//public var m_resMgrNoProg:IResourceManager;		// 如果不显示进度的从这个加载,地形、特效、人物，这些资源从这里加载
		public var m_soundMgr:ISoundManager;
		public var m_embeddedResourceProvider:IResourceProvider;
		public var m_fallbackResourceProvider:IResourceProvider;
		
		public var m_sceneSocket:IWorldHandler;	// 这个是客户端和服务器通信的主要 socket 
		//public var m_embeddedResourceProvider:Vector.<IResourceProvider>;
		//public var m_fallbackResourceProvider:Vector.<IResourceProvider>;
		
		//public var m_thingManager:IThingManager;		
		public var m_playerResID:String;
		public var m_binHeroSel:Boolean;			// 是否在角色选择界面
		public var m_bFirstCreateAndEnter:Boolean;		// 第一次创建角色进入场景
		public var m_bNewHero:Boolean;		// 当前角色是在本次登陆时创建的
		public var m_fCreateHero:Function;		// 创建角色回调
		public var m_npcBattleMgr:INpcBattleMgr;
		public var m_sceneView:ISceneView;
		
		public var m_playerResMgr:PlayerResMgr;
		public var m_mainStage:Stage;
		public var m_rootNode:Sprite;	// 整个显示的根节点  
		public var m_layList:Vector.<Sprite>;
		
		public var m_processManager:IProcessManager;
		public var m_inputManager:IInputManager;
		public var m_sceneResMgr:fSceneResourceManager;
		public var m_uiObjMgr:fUIObjectMgr;
		public var m_dragResPool:DragResPool;
		protected var m_msgBufferFlag:uint;
		public var m_path:IPath;			// 路径查找
		
		public var m_LoginData:LoginData;
		public var m_LoginMgr:LoginMgr;
		public var m_platformMgr:PlatformMgr;
		public var m_preLoad:PreLoad;
		public var m_HttpCom:HttpCom;
		// 配置信息 
		public var m_config:Config;
		//登陆方面的数据
		//public var m_LoginData:Object;
		//主动重置大小
		//public var m_canvas:BrowserCanvas;
		
		// 各个模块之间通信的函数 
		//public var m_loginFunc:Function;	// 登录登录服务器
		//public var m_gatewayFunc:Function;	// 登录网关服务器 
		//public var m_unloadLoginFunc:Function;	// 登录成功后卸载登录模块 
		//public var m_netState:uint = 0;	// 网络状态 
		
		public var m_terrainManager:ITerrainManager;
		//public var m_sceneState:int = EntityCValue.SSIniting;
		public var m_count:Number = 0;
		
		//public var m_sceneLogic:ISceneLogic;	// 场景逻辑处理  
		//public var m_fightControl:IFightController;	// 战斗控制器  		
		//public var m_beingProp:IBeingProp;		// 所有 hero 属性  
		//public var m_tblMgr:ITblManager;		// 表管理器，表基本都存放在这里
		public var m_commonImageMgr:CommonImageManager;		
		public var m_typeReg:TypeReg;
		public var m_profiler:IProfiler;	// 正是加入配置，测试效率     
		public var m_stats:Stats;			// 显示基础的调试信息    
		public var m_hdRes:SWFResource = null;		// 掉血数字资源，公用一个就行了 
		
		public var m_SObjectMgr:ShareObjectMgr;
		public var m_debugLog:IUIDebugLog;
		public var m_gameCursor:GameCursor; //鼠标管理器
		//public var m_playerPlace:BitmapData;	// 这个是玩家的占位资源
		public var m_globalObj:GlobalObject;
		//public var m_thingPlace:BitmapData;	// 这个是地上物的占位资源
		public var m_shaderMgr:ShaderMgr;
		//public var m_verInfo:VersionAllInfo;		// 版本信息
		public var m_verInfoFun:Function;		// 版本信息
		public var m_version:String;
		public var m_bPrintMsgName:Boolean;
		public var m_contentBuffer:ContentBuffer; //用于缓存一些东西, 其key必须保证与其它模块不同，
		
		public var m_objonStageMOUSE_DOWN:Object;
		//public var m_preFrame:uint = uint.MAX_VALUE;	// 上一个帧号
		//public var m_curFrame:uint = 0;				// 当前帧号
		//public var m_newCnt:int = 0;	// 构造次数
		//public var m_disposeCnt:int = 0;	// 释放次数
		public var m_enterSceneCB:Function;		// 进入场景
		public var m_cryptoSys:CryptoSys;				// 加密解密系统
		
		public var m_timeMgr:TimeMgr;
		public var m_replaceResSys:IReplaceResSys;
		public var m_idleTimeProcessMgr:IdleTimeProcessMgr;
		public var progLoading:UIProgLoading;		// 程序启动进度条
		public var m_logContent:String;	//记录日志内容
		public var m_timesOfSendToDataBase:int;
		public function Context() 
		{
			m_logContent = "";
			m_rootNode = new Sprite();
			m_rootNode.name = "m_rootNode";
			m_layList = new Vector.<Sprite>(Context.TLayCnt, true);
			var k:uint = 0;
			while (k < Context.TLayCnt)
			{
				m_layList[k] = new Sprite();
				m_rootNode.addChild(m_layList[k]);
				++k;
			}
			m_layList[Context.TLayUI].mouseEnabled = false;
			m_config = new Config();
			m_HttpCom = new HttpCom(this);
			m_typeReg = new TypeReg();
			m_SObjectMgr = new ShareObjectMgr();
			m_gameCursor = new GameCursor(this);
			DragManager.s_context = this;
			
			m_globalObj = new GlobalObject();
			m_shaderMgr = new ShaderMgr();
			m_cryptoSys = new CryptoSys();
			m_dragResPool = new DragResPool();
			m_idleTimeProcessMgr = new IdleTimeProcessMgr();
			m_platformMgr = new PlatformMgr(this);
			m_LoginData = new LoginData();
			m_LoginMgr = new LoginMgr(this);
			m_timeMgr = new TimeMgr(this);
			m_contentBuffer = new ContentBuffer();
			m_playerResMgr = new PlayerResMgr();
		}
		
		public function init():void
		{
			//m_resMgr = new ResourceManager();
			//m_soundMgr = new SoundManager();
			//m_embeddedResourceProvider = new EmbeddedResourceProvider();
			//m_FallbackResourceProvider = new FallbackResourceProvider();
			
			//m_playerManager = new PlayerManager();
			//m_thingManager = new ThingManager();
			//m_sceneView = new sceneviewer();
			//m_processManager = new ProcessManager();
		}
		
		public function set mainStage(st:Stage):void
		{
			m_mainStage = st;
			
			// 和舞台有关的设置在这里
			//m_config.m_stageWidth = m_mainStage.stageWidth;
			//m_config.m_stageHeight = m_mainStage.stageHeight;
			//adjustWindowPos();
			Logger.info(null, null, "stage width: width=" + m_config.m_stageWidth +　" height=" + m_config.m_stageHeight);
			
			// 只有不是从浏览器启动的时候才设置各种类型    
			//if (!m_config.m_browser)
			//{
				setStyle();
			//}
			
			// KBEN: 浏览器兼容有问题，不要用这个函数   
			// m_canvas = new BrowserCanvas(m_mainStage);
			
			
			//这是调试语句,先注释掉这一行
			m_mainStage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMOUSE_DOWN);
		}
		public function onStageMOUSE_DOWN(e:MouseEvent):void
		{
			m_objonStageMOUSE_DOWN = e.target;			
		}
		public function get mainStage():Stage
		{
			return m_mainStage;
		}
		
		public function set gkcontext(value:IGKContext):void 
		{
			m_gkcontext = value;
		}
		
		public function initNode(sp:Sprite):void
		{
			//var k:uint = 0;
			//while (k < Context.TLayCnt)
			//{
			//	sp.addChild(m_layList[k]);
			//	++k;
			//}
			
			sp.addChild(m_rootNode);
			
			// 上层添加   
			//m_layList[TLayUI].addChild(m_UIMgr as Sprite);
		}
		
		/**
		 * @brief 设置舞台属性    
		 */
		public function setStyle():void
		{
			m_mainStage.align = StageAlign.TOP_LEFT;			// align: "top"    
			m_mainStage.scaleMode = StageScaleMode.NO_SCALE;	// scale: "noScale"
		}

		
		
		// 获取层     
		public function getLay(idx:uint):Sprite
		{
			if (idx < Context.TLayCnt)
			{
				return m_layList[idx];
			}
			
			return null;
		}
		
		// 调整窗口大小以及位置，分辨率改变的时候也需要调用这个          
		public function adjustWindowPos():Boolean
		{
			m_config.m_stageWidth = m_mainStage.stageWidth;
			m_config.m_stageHeight = m_mainStage.stageHeight;
			
			var sceneWidth:uint;
			var sceneHeight:uint;
			var scene:fScene;
			if (m_sceneView)
			{
				scene = m_sceneView.curScene();
			}			
			
			if (scene)
			{				
				if (m_sceneView.curSceneType == EntityCValue.SCFIGHT)
				{
					sceneWidth = 1920;
					sceneHeight = EntityCValue.FIGHTSCENE_SHOW_HEIGHT;
				}
				else
				{					
					sceneWidth = scene.widthpx();
					sceneHeight = scene.heightpx();
				}
			}
			else
			{
				sceneWidth = m_config.m_stageWidth;
				sceneHeight = m_config.m_stageHeight;
			}
			
			
			var origx:uint = 0;
			var origy:uint = 0;
			
			var clipwidth:uint = 0;
			var clipheight:uint = 0;
			
			var prewidth:uint = m_config.m_curWidth;
			var preheight:uint = m_config.m_curHeight;
			var bchange:Boolean = false;	// 大小是否改变
			
			// 宽度界定
			if (m_config.m_stageWidth >= sceneWidth)
			{				
				m_config.m_curWidth = sceneWidth;
				origx = (m_config.m_stageWidth - m_config.m_curWidth) / 2;								
			}
			else
			{
				m_config.m_curWidth = m_config.m_stageWidth;
				origx = 0;
			}
			clipwidth = m_config.m_curWidth;
			
			// 高度 
			if (m_config.m_stageHeight >= sceneHeight)
			{
				m_config.m_curHeight = sceneHeight;
				origy = (m_config.m_stageHeight - m_config.m_curHeight) / 2;						
			}
			else
			{
				m_config.m_curHeight = m_config.m_stageHeight;
				origy = 0;
				clipheight = m_config.m_curHeight;
			}
			clipheight = m_config.m_curHeight;
			
			m_rootNode.x = origx;
			m_rootNode.y = origy;
			
			m_config.m_showWidth = m_config.m_curWidth;
			m_config.m_showHeight = m_config.m_curHeight;
			
			// 战斗场景不能太小,太小会将某些东西裁减掉
			if(scene && m_sceneView)
			{
				if (m_sceneView.curSceneType == EntityCValue.SCFIGHT)
				{
					if(m_config.m_curWidth < m_config.m_minWidth)
					{
						m_config.m_curWidth = m_config.m_minWidth;
					}
					if(m_config.m_curHeight < m_config.m_minHeight)
					{
						m_config.m_curHeight = m_config.m_minHeight;
					}
				}
			}
			
			var rect:Rectangle = new Rectangle(0, 0, clipwidth, clipheight);
			this.m_rootNode.scrollRect = rect;
			
			if (prewidth != m_config.m_curWidth || preheight != m_config.m_curHeight)
			{
				bchange = true;
			}
			return bchange;
		}
		
		public function loadHDRes():void
		{
			if (!m_hdRes)
			{
				m_hdRes = this.m_resMgr.load(m_path.getPathByID(0, EntityCValue.RESHDIGIT), SWFResource, onHDResLoaded, onHDResFailed) as SWFResource;
			}
		}
		
		// 掉血数字资源加载成功    
		public function onHDResLoaded(event:ResourceEvent):void
		{
			
		}
		
		public function onHDResFailed(event:ResourceEvent):void
		{
			var path:String = event.resourceObject.filename;
			Logger.error(null, null, path + "load failed");
			
			// 删除资源，一定要减少引用计数    
			//m_hdRes.decrementReferenceCount();
			m_hdRes = null;
			
			this.m_resMgr.unload(path, SWFResource);
		}
		
		public function bHDresLoaded():Boolean
		{
			return m_hdRes && m_hdRes.isLoaded;
		}
		/*
		 * 将全局位置（相对于stage），转换为m_rootNode上的局部位置。这个局部位置也是在屏幕中的位置
		 */
		public function golbalToScreen(pt:Point):Point
		{
			return m_rootNode.globalToLocal(pt);
		}
		
		public function mouseScreenPos():Point
		{
			return golbalToScreen(new Point(mainStage.mouseX, mainStage.mouseY));
		}
		
		public function linkOff(beingid:uint, effid:uint):Point
		{
			return m_gkcontext.linkOff(beingid, effid);
		}
		
		public function getTagHeight(beingid:uint):int
		{
			return m_gkcontext.getTagHeight(beingid);
		}
		
		public function getLink1fHeight(beingid:uint):int
		{
			return m_gkcontext.getLink1fHeight(beingid);
		}
		
		public function modelOff(beingid:uint, act:uint, dir:uint):Point
		{
			return m_gkcontext.modelOff(beingid, act, dir);
		}
		
		public function modelOffAll(beingid:uint):fActDirOff
		{
			return m_gkcontext.modelOffAll(beingid);
		}
		
		public function modelMountserOffAll(beingid:uint):fActDirOff
		{
			return m_gkcontext.modelMountserOffAll(beingid);
		}
		
		// 获取模型动作帧率
		public function modelFrameRate(beingid:uint):Dictionary
		{
			return m_gkcontext.modelFrameRate(beingid);
		}
		
		public function effFrame(effid:uint):uint
		{
			return m_gkcontext.effFrame(effid);
		}
		
		public function effFrame2scale(effid:uint):Dictionary
		{
			return m_gkcontext.effFrame2scale(effid);
		}
		
		public function get curMapID():uint
		{
			return m_gkcontext.curMapID;
		}
		 
		public function get bInBattleIScene():Boolean
		{
			return m_gkcontext.bInBattleIScene;
		}
		
		// 获取 stage 焦点,可以监听全局键盘事件
		public function focusStage():void
		{
			// 必须要点击一下才能获取全局键盘事件
			//this.m_mainStage.focus = m_mainStage;
			if(m_mainStage)
			{
				//this.m_mainStage.dispatchEvent( new MouseEvent( MouseEvent.CLICK ));
				this.m_mainStage.focus = m_mainStage;
			}
		}
		
		public function isSetLocalFlags(flag:uint):Boolean
		{
			return m_gkcontext.isSetLocalFlags(flag);
		}
		public function addLog(str:String):void
		{      
			if (m_logContent.length > 800000)
			{
				m_logContent = m_logContent.slice(400000);
			}
			if (m_timeMgr.isInit)
			{
				m_logContent += m_timeMgr.timeString + "  " + str + "\n";
			}
			else
			{
				m_logContent += getTimer() + " " + str + "\n";
			}
		}
		public function set sceneSocket(value:IWorldHandler):void
		{
			m_sceneSocket = value;
			m_sceneSocket.cryptoSys = m_cryptoSys;
		}
		
		public function sendMsg(cmd:t_NullCmd):void
		{
			if (m_sceneSocket)
			{
				var strLog:String="send msg: Cmd=" + cmd.byCmd + ", Param=" + cmd.byParam;
				if (m_bPrintMsgName)
				{
					strLog += " name=" + stNullUserCmd.getMsgName(cmd.byCmd,cmd.byParam);
				}
				
				Logger.info("", "", strLog);
				m_sceneSocket.sendMsg(cmd);
			}
			else
			{
				if (!this.m_LoginMgr.m_inProcessOfKuafuLogin)
				{
					DebugBox.info("Context::sendMsg: m_sceneSocket == null");
				}
			}
		}
		public function setLoad(bit:uint):void
		{
			m_preLoad.setLoad(bit);
		}
		
		public function sendErrorToDataBase(str:String, type:int = 1):void
		{
			if (m_timesOfSendToDataBase > 4)
			{
				return;
			}
			if (m_config.m_versionForOutNet == false)
			{
				return;
			}
			m_timesOfSendToDataBase++;
			
			var httpCmd:HttpCmdBase = m_HttpCom.createHttpCmd(str, type);
			if (m_gkcontext)
			{
				m_gkcontext.getMoreGameInfo(httpCmd);
			}
			m_HttpCom.sendHttpMsg(httpCmd);
		}
		
		public function onUncaughtErrorHappened(event:UncaughtErrorEvent):void
		{
			var message:String;
             var type:int=0;
             if (event.error is Error)
             {
				 var error:Error = (event.error) as Error;
				 type = error.errorID;
                 message = error.message+error.getStackTrace();
             }
             else if (event.error is ErrorEvent)
             {
				 var ee:ErrorEvent = (event.error) as ErrorEvent;
                 message = ee.text;
             }
             else
             {
                 message = event.error.toString();
             }
			
			 sendErrorToDataBase(message, type)
			 DebugBox.info(message);
			 event.stopImmediatePropagation();
		}
		public function setMsgBufferFlag(flag:int):void
		{
			m_msgBufferFlag = UtilCommon.setStateUint(m_msgBufferFlag, flag);
		}
		public function clearMsgBufferFlag(flag:int):void
		{
			m_msgBufferFlag = UtilCommon.clearStateUint(m_msgBufferFlag, flag);
		}
		public function get isMsgBuffer():Boolean
		{
			return m_msgBufferFlag > 0;
		}
	}
}