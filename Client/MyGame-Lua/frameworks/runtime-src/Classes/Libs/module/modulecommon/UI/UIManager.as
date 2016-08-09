package modulecommon.ui
{
	import com.pblabs.engine.core.IResizeObject;
	import com.pblabs.engine.core.ITimeUpdateObject;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.idleprocess.IIdleTimeProcess;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.events.UncaughtErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.UIBattleSceneShadow;
	import modulecommon.appcontrol.UIDebugLog;
	import modulecommon.appcontrol.UIMapSwitchEffect;
	import modulecommon.appcontrol.UIMenu;
	import modulecommon.appcontrol.menu.UIMenuEx;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUIMgrForGame;
	import com.pblabs.engine.entity.EntityCValue;
	
	/**
	 * ...
	 * @author ...
	 * @brief 所有 UI 管理
	 * 1. 对于新创建的Form对象，其所属的层是由其ID决定的
	 * 2. 通过switchFormToLayer()， 可将Form对象放到任何层
	 */
	public class UIManager extends Sprite implements IResizeObject, ITimeUpdateObject, IIdleTimeProcess
	{
		private var m_gkcontext:GkContext;
		private var m_excludeList:Array;
		private var m_zeroLayer:Sprite;
		private var m_uiLayer:Sprite;
		private var m_topMostLayer:Sprite; //最上层
		
		private var m_dicForm:Dictionary; //[id,form]
		private var vecLayer:Vector.<UILayer>;
		public var m_UIResDic:Dictionary;
		public var m_path2ID:Dictionary = new Dictionary(); // 路径到 ID 的映射    
		public var m_dicFormIDLoaded:Dictionary; //如果一个界面曾经加载过，则其ID会记录在m_dicFormIDLoaded对象中
		
		public var m_UIFormIDConstantNameList:Vector.<String>;
		public var m_dicIDToFormIDConstantName:Dictionary;
		public var m_uiGgrForGame:IUIMgrForGame;
		
		public var m_showLog:Boolean;
		public var m_bOpenFromInNpcTalkEnd:Boolean;		//与npc对话结束后，是否打开一个界面
		private var m_imageSWFLoaderMgr:ImageSWFLoader_FormMgr;
		private var m_gameCBUIEvent:CBUIEvent;
		
		public function UIManager(context:GkContext)
		{
			m_gkcontext = context;
			m_imageSWFLoaderMgr = new ImageSWFLoader_FormMgr(m_gkcontext);
			m_dicFormIDLoaded = new Dictionary();
			m_zeroLayer = new Sprite();
			m_zeroLayer.mouseEnabled = false;
			addChild(m_zeroLayer);
			
			m_uiLayer = new Sprite();
			m_uiLayer.mouseEnabled = false;
			addChild(m_uiLayer);
			
			m_topMostLayer = new Sprite();
			m_topMostLayer.mouseEnabled = false;
			addChild(m_topMostLayer);
			
			vecLayer = new Vector.<UILayer>;
			vecLayer.push(new UILayer(UIFormID.FirstLayer)); //低层桌面
			vecLayer.push(new UILayer(UIFormID.SecondLayer)); //中层桌面
			vecLayer.push(new UILayer(UIFormID.ThirdLayer)); //上层桌面
			vecLayer.push(new UILayer(UIFormID.FourthLayer)); //最上层桌面，这个桌面是存在于普通场景与战斗场景上的
			vecLayer.push(new UILayer(UIFormID.BattleLayer)); //在战斗场景中显示的桌面			
			vecLayer.push(new UILayer(UIFormID.ProgLoading)); //加载进度条
			vecLayer.push(new UILayer(UIFormID.CGLayer)); // CG 动画层
			vecLayer.push(new UILayer(UIFormID.PlaceLayer)); //占位层，不显示
			m_uiLayer.addChild(vecLayer[UIFormID.FirstLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.SecondLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.ThirdLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.FourthLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.ProgLoading].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.CGLayer].deskTop);
			m_UIResDic = new Dictionary;
			m_dicForm = new Dictionary;
			
			m_gkcontext.m_context.m_processManager.addResizeObject(this, EntityCValue.ResizeUI);
			m_gkcontext.m_context.m_processManager.add10MinuteUpateObject(this);
			
			// UI 层全部忽略鼠标消息      
			this.mouseEnabled = false;
			vecLayer[UIFormID.FirstLayer].deskTop.mouseEnabled = false;
			vecLayer[UIFormID.SecondLayer].deskTop.mouseEnabled = false;
			vecLayer[UIFormID.ThirdLayer].deskTop.mouseEnabled = false;
			vecLayer[UIFormID.FourthLayer].deskTop.mouseEnabled = false;
			vecLayer[UIFormID.BattleLayer].deskTop.mouseEnabled = false;
			vecLayer[UIFormID.ProgLoading].deskTop.mouseEnabled = false;
			
			m_gameCBUIEvent = new CBUIEvent(m_gkcontext);
			m_gkcontext.m_cbUIEvent = m_gameCBUIEvent;
			init();
			createFormIDConstantNameList();
		}
		
		public function getLayer(layerID:uint):UILayer
		{
			var layer:UILayer;
			
			if (layerID >= UIFormID.FirstLayer && layerID <= UIFormID.MaxLayer)
			{
				layer = vecLayer[layerID];
			}
			return layer;
		}
		
		public function addForm(form:Form):void
		{
			var layer:UILayer = getLayer(UIFormID.Layer(form.id));
			form.uiLayer = layer;
			m_dicForm[form.id] = form;
			form.gkcontext = m_gkcontext;
			form.onReady();
		}
		
		public function loadForm(ID:uint):void
		{
			var path:String = m_gkcontext.m_UIPath.getPath(ID);
			m_path2ID[path] = ID;
			var window:Form = getForm(ID);
			
			if (window != null)
			{
				var loadedFun:Function = m_gkcontext.m_cbUIEvent.getLoadedFunc(ID);
				if (loadedFun != null)
				{
					loadedFun(window);
				}
			}
			else // 可能资源已经加载过了,启动的时候把一些必要的界面全部读取进来
			{
				var res:SWFResource = m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource; // 检查资源是否加载
				var uiRes:UIResourceLoading = m_UIResDic[path];
				if (res) // 如果资源已经加载了，但是 form 还没有构建，就直接构建，不再加载
				{
					if (!uiRes) // 如果不存在，就说明资源加载过，但是界面没有构建出来
					{
						uiRes = new UIResourceLoading;
						uiRes.id = ID;
						
						// 这一行放在 load 上面，如果资源已经加载进来了，放在下面 onloadedSWF 会有问题
						m_UIResDic[path] = uiRes;
					}
					
					if (!res.isLoaded) // 正在加载但是没有加载完成
					{
						// 添加事件监听,不用增加引用计数
						res.addEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
						res.addEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
					}
					else // 已经加载完成
					{
						onloadedSWFByRes(res);
					}
				}
				else // 资源从来没有加载过
				{
					if (uiRes != null)
					{
						m_gkcontext.addLog("loadForm:正在加载" + path);
						return;
					}
					else
					{
						Logger.info(null, null, "Loading " + path);
						uiRes = new UIResourceLoading;
						uiRes.id = ID;
						//m_gkcontext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF);
						//m_UIResDic[path] = uiRes;
						
						// 这一行放在 load 上面，如果资源已经加载进来了，放在下面 onloadedSWF 会有问题
						m_UIResDic[path] = uiRes;
						// 如果不是在进入场景时期，就显示加载环形进度
						if (!m_gkcontext.m_context.progLoading.isVisible() && m_dicFormIDLoaded[ID] == undefined && UIFormID.hasCircleLoadingEffect(ID))
						{
							// loadRes 放在 load 上面，如果 swf 资源已经加载，就会有问题						
							m_gkcontext.m_UIs.circleLoading.loadRes(path);
						}
						var ad:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
						var lc:LoaderContext = new LoaderContext();
						lc.applicationDomain = ad;
						m_gkcontext.m_context.m_resMgr.load(path, SWFResource, onloadedSWF, onFailedSWF, onProgressSWF, onStartedSWF, false, lc);
					}
				}
			}
		}
		
		public function getForm(ID:uint):Form
		{
			return m_dicForm[ID];
		}
		
		public function hasForm(ID:uint):Boolean
		{
			return (m_dicForm[ID] != undefined);
		}
		
		//显示出指定界面，如果对应的工程还没有下载，则直接下载
		public function showFormEx(ID:uint):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("加载" + getFormName(ID));
			}
			if (hasForm(ID))
			{
				if (m_showLog)
				{
					m_gkcontext.addLog("调用showForm");
				}
				showForm(ID);
			}
			else
			{
				if (m_showLog)
				{
					m_gkcontext.addLog("调用loadForm");
				}
				loadForm(ID);
			}
		}
		
		//显示出指定界面，如果对象不存在，则直接创建
		public function showFormInGame(ID:uint):Form
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("加载" + getFormName(ID));
			}
			var form:Form = this.getForm(ID);
			if (form == null)
			{
				form = this.createFormInGame(ID);
			}
			form.show();
			return form;
		}
		/*
		 * 先加载图片包，再创建Form对象
		 * 在加载图片包时，显示进度
		 */ 
		public function showFormWidthProgress(ID:uint):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("showFormWidthProgress" + getFormName(ID));
			}
			var form:Form = this.getForm(ID);
			if (form)
			{
				form.show();
				return;
			}
			if (m_showLog)
			{
				m_gkcontext.addLog("Form不存在" + getFormName(ID));
			}
			m_imageSWFLoaderMgr.showForm(ID);
		}
		
		/*
		 * 先加载图片包，再创建Form对象
		 * 在加载图片包时，不显示进度条
		 */
		public function showFormWidthNoProgress(ID:uint):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("showFormWidthProgress" + getFormName(ID));
			}
			var form:Form = this.getForm(ID);
			if (form)
			{
				form.show();
				return;
			}
			if (m_showLog)
			{
				m_gkcontext.addLog("Form不存在" + getFormName(ID));
			}
			m_imageSWFLoaderMgr.showForm_NoProgress(ID);
		}
		
		public function showForm(ID:uint):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("showForm:" + getFormName(ID));
			}
			if (this.onShowForm(ID) == false)
			{
				if (m_showLog)
				{
					m_gkcontext.addLog("showForm:this.onShowForm(ID) == false");
				}
				return;
			}
			var win:Form = getForm(ID);
			if (win != null)
			{
				if (m_showLog)
				{
					m_gkcontext.addLog("showForm:" + getFormName(ID) + "  执行显示操作");
				}
				var layer:UILayer = win.uiLayer;
				if (win.isInitiated)
				{
					if (win.parent != layer.deskTop)
					{
						layer.deskTop.addChild(win);
						win.onShow();
						// 播放音效
						if (win.m_ocMusic)
						{
							m_gkcontext.m_commonProc.playMsc(51);
						}
					}
					else
					{
						layer.deskTop.addChild(win);	//move to top
					}
				}
				else
				{
					m_gkcontext.addLog("showForm: 还未初始化--" + m_dicIDToFormIDConstantName[ID]);
				}
				
			}
		}
		
		public function hideForm(ID:uint):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("hideForm:" + getFormName(ID));
			}
			var win:Form = getForm(ID);
			if (win != null)
			{
				var layer:UILayer = win.uiLayer;
				if (win.parent == layer.deskTop)
				{
					if (m_showLog)
					{
						m_gkcontext.addLog("hideForm:" + getFormName(ID)+"隐藏界面");
					}
					m_gkcontext.m_confirmDlgMgr.clearOnFormID(ID);
					layer.deskTop.removeChild(win);
					// 播放音效
					if (win.m_ocMusic)
					{
						m_gkcontext.m_commonProc.playMsc(52);
					}
					win.onHide();
				}
			}
		}
		
		/*
		 * 判断指定(ID)的界面是否是UIManager的孩子
		 */
		public function isFormAttached(ID:uint):Boolean
		{
			var win:Form = getForm(ID);
			return win && win.parent != null;
		}
		
		/*
		 * 判断指定(ID)的界面是否可见
		 */
		public function isFormVisible(ID:uint):Boolean
		{
			return isFormAttached(ID);
		}
		
		//关闭界面
		public function exitForm(ID:uint):void
		{
			var win:Form = getForm(ID);
			if (win != null)
			{
				var layer:UILayer = win.uiLayer;
				// 播放音效
				if (win.m_ocMusic)
				{
					m_gkcontext.m_commonProc.playMsc(51);
				}
				win.exit();
				
			}
		}
		
		public function destroyForm(ID:uint):void
		{
			var win:Form = getForm(ID);
			
			if (win != null)
			{
				var layer:UILayer = win.uiLayer;
				
				m_gkcontext.m_confirmDlgMgr.clearOnFormID(ID);
				if (win.parent == layer.deskTop)
				{
					layer.deskTop.removeChild(win);
					win.onHide();
				}
				
				win.onDestroy();
				win.dispose();				
				delete layer.winDic[ID];
				var path:String = m_gkcontext.m_UIPath.getPath(ID);
				if (path)
				{
					win.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, m_gkcontext.m_context.onUncaughtErrorHappened);
					m_gkcontext.m_context.m_resMgr.unload(path, SWFResource);
				}
				delete m_dicForm[ID];
				win = null;
			}
		
			// bug: 关闭 UI 的时候恢复 Stage 焦点,不知道为什么下一个循环会被设置成 focus = null
			//m_gkcontext.m_context.focusStage();
		}
		
		public function uiID(path:String):uint
		{
			return m_path2ID[path];
		}
		
		// 资源加载成功，通过事件回调
		public function onloadedSWF(event:ResourceEvent):void
		{
			if (m_showLog)
			{
				m_gkcontext.addLog("Loaded " + event.resourceObject.filename);
			}
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			var resource:SWFResource = event.resourceObject as SWFResource;
			onloadedSWFByRes(resource);
		}
		
		// 资源加载失败，通过事件回调
		private function onFailedSWF(event:ResourceEvent):void
		{
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWF);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWF);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			/*
			   Logger.error(null, null, "failed " + resource.resourceObject.filename);
			   m_gkcontext.addLog("failed " + resource.resourceObject.filename);
			   var uiRes:UIResourceLoading = m_UIResDic[resource.resourceObject.filename];
			   if (uiRes != null)
			   {
			   delete m_UIResDic[resource.resourceObject.filename];
			   return;
			   }
			
			   // 加载进度条
			   if (m_gkcontext.m_UIs.progLoading.isVisible())
			   {
			   m_gkcontext.m_UIs.progLoading.progResFailed(resource.resourceObject.filename);
			   }
			   else
			   {
			   m_gkcontext.m_UIs.circleLoading.circleResFailed(resource.resourceObject.filename);
			   }
			 */
			
			onFailedSWFByRes(event.resourceObject as SWFResource);
		}
		
		// 资源加载完成,通过资源直接回调
		public function onloadedSWFByRes(resource:SWFResource):void
		{
			try
			{
				var uiRes:UIResourceLoading = m_UIResDic[resource.filename];
				if (m_showLog)
				{
					m_gkcontext.addLog("Loaded " + resource.filename);
				}
				
				if (uiRes == null)
				{
					return;
				}
				delete m_UIResDic[resource.filename];
				
				if (resource is SWFResource)
				{
					var swfRes:SWFResource = resource as SWFResource;
					
					var layer:UILayer = getLayer(UIFormID.Layer(uiRes.id));
					if (layer == null)
					{
						return;
					}
					
					var window:Form = swfRes.content as Form;
					window.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, m_gkcontext.m_context.onUncaughtErrorHappened);
					window.id = uiRes.id;
					window.gkcontext = m_gkcontext;
					m_dicForm[window.id] = window;
					window.uiLayer = layer;
					window.swfRes = swfRes;
					if (window.hideOnCreate == true)
					{
						if (window.parent is Loader)
						{
							layer.deskTop.addChild(window);
							layer.deskTop.removeChild(window);
						}
					}
					if (m_showLog)
					{
						m_gkcontext.addLog("开始执行onReady() " + resource.filename);
					}
					window.onReady();
					if (m_showLog)
					{
						m_gkcontext.addLog("执行完onReady() " + resource.filename);
					}
					
					
					if (m_gkcontext.m_cbUIEvent)
					{
						var loadedFun:Function = m_gkcontext.m_cbUIEvent.getLoadedFunc(uiRes.id);
						loadedFun(window);
					}
					else
					{
						showForm(window.id);
					}
					
					//
					m_dicFormIDLoaded[window.id] = true;
				}
				
				// 加载进度条
				if (m_gkcontext.m_context.progLoading.isVisible())
				{
					m_gkcontext.m_context.progLoading.progResLoaded(resource.filename);
				}
				else
				{
					m_gkcontext.m_UIs.circleLoading.circleResLoaded(resource.filename);
				}
			}
			catch (e:Error)
			{
				if (m_gkcontext.m_context.progLoading.isVisible())
				{
					m_gkcontext.m_context.progLoading.progResLoaded(resource.filename);
				}
				else
				{
					m_gkcontext.m_UIs.circleLoading.circleResLoaded(resource.filename);
				}
				var strLog:String = "failed " + resource.filename + " throw error " + e.message + "\n堆栈" + e.getStackTrace();
				
				m_gkcontext.addLog(strLog);
				Logger.error(null, null, strLog);
			}
		}
		
		// 资源加载失败，通过资源直接回调
		private function onFailedSWFByRes(resource:SWFResource):void
		{
			Logger.error(null, null, "failed " + resource.filename);
			m_gkcontext.addLog("failed " + resource.filename);
			var uiRes:UIResourceLoading = m_UIResDic[resource.filename];
			if (uiRes != null)
			{
				delete m_UIResDic[resource.filename];
				return;
			}
			
			// 加载进度条
			if (m_gkcontext.m_context.progLoading.isVisible())
			{
				m_gkcontext.m_context.progLoading.progResFailed(resource.filename);
			}
			else
			{
				m_gkcontext.m_UIs.circleLoading.circleResFailed(resource.filename);
			}
		}
		
		private function onProgressSWF(event:ResourceProgressEvent):void
		{
			if (m_gkcontext.m_context.progLoading.isVisible()) // 进度条
			{
				m_gkcontext.progResProgress(event.resourceObject.filename, event._percentLoaded);
			}
			else //环形进度条
			{
				m_gkcontext.circleResProgress(event.resourceObject.filename, event._percentLoaded);
			}
		}
		
		private function onStartedSWF(event:ResourceEvent):void
		{
			// 加载进度条
			if (m_gkcontext.m_context.progLoading.isVisible()) // 进度条
			{
				m_gkcontext.progResStarted(event.resourceObject.filename);
			}
			else
			{
				m_gkcontext.circleResStarted(event.resourceObject.filename);
			}
		}
		
		//stage的大小发生变化后，调用此函数
		public function onResize(viewWidth:int, viewHeight:int):void
		{
			var index:int;
			for (index = 0; index <= UIFormID.MaxLayer; index++)
			{
				vecLayer[index].onStageReSize();
			}
		}
		
		private function init():void
		{
			var form:Form;
			form = new UIMenu();
			this.addForm(form);
			
			form = new UIMenuEx();
			this.addForm(form);
						
			
			m_gkcontext.m_uiMapSwitchEffect = new UIMapSwitchEffect();
			this.addForm(m_gkcontext.m_uiMapSwitchEffect);
			
			m_excludeList = [UIFormID.UINpcTalk, UIFormID.UITask, UIFormID.UIZhenfa, UIFormID.UIBackPack, UIFormID.UIEquipSys, UIFormID.UIZhanxing,
			UIFormID.UIOtherPlayer, UIFormID.UIWatchPlayer, UIFormID.UIWuXiaye, UIFormID.UIXingMai, UIFormID.UIGuoguanzhanjiang, UIFormID.UISaoDangReward,
			UIFormID.UISaoDangIngInfo, UIFormID.UIMarket, UIFormID.UICorpsInfo, UIFormID.UIFastSwapEquips, UIFormID.UISanguoZhangchangEnter, UIFormID.UIXuanShangRenWu,
			UIFormID.UITongQueWuHui,UIFormID.UITreasureHunt,UIFormID.UIRechatge,UIFormID.UIDTRechatge];
		}
		
		/*
		 * 进入战斗场景时，调用此函数，隐藏正常界面，显示战斗界面
		 */
		public function switchToBattleScene():void
		{
			m_uiLayer.removeChild(vecLayer[UIFormID.FirstLayer].deskTop);
			m_uiLayer.removeChild(vecLayer[UIFormID.SecondLayer].deskTop);
			m_uiLayer.removeChild(vecLayer[UIFormID.ThirdLayer].deskTop);
			m_uiLayer.removeChild(vecLayer[UIFormID.FourthLayer].deskTop);
			m_uiLayer.removeChild(vecLayer[UIFormID.ProgLoading].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.BattleLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.FourthLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.ProgLoading].deskTop);
			var form:Form = this.getForm(UIFormID.UIBattleSceneShadow);
			if (form == null)
			{
				form = new UIBattleSceneShadow();
				this.addForm(form);
			}
			form.show();
		}
		
		public function closeAllFormInDesktop(iDesk:int):void
		{
			vecLayer[iDesk].closeAllForm();
		}
		
		/*
		 * 离开战斗场景时，调用此函数，显示正常界面，隐藏战斗界面
		 */
		public function leaveFromBattleScene():void
		{
			m_uiLayer.removeChild(vecLayer[UIFormID.BattleLayer].deskTop);
			m_uiLayer.removeChild(vecLayer[UIFormID.FourthLayer].deskTop);
			
			m_uiLayer.addChild(vecLayer[UIFormID.FirstLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.SecondLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.ThirdLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.FourthLayer].deskTop);
			m_uiLayer.addChild(vecLayer[UIFormID.ProgLoading].deskTop);
			
			this.destroyForm(UIFormID.UIBattleSceneShadow);
		}
		
		// 新手地图 UI 设置
		public function switchToFirScene():void
		{
			m_uiLayer.removeChild(vecLayer[UIFormID.FirstLayer].deskTop);
			//m_uiLayer.removeChild(vecLayer[UIFormID.ThirdLayer].deskTop);
			//addChild(vecLayer[UIFormID.SecondLayer].deskTop);
		}
		
		public function leaveFromFirScene():void
		{
			m_uiLayer.addChild(vecLayer[UIFormID.FirstLayer].deskTop);
			//m_uiLayer.addChild(vecLayer[UIFormID.ThirdLayer].deskTop);
			m_uiLayer.setChildIndex(vecLayer[UIFormID.ThirdLayer].deskTop, 2);
		}
		
		public function onShowForm(id:uint):Boolean
		{
			var i:int = m_excludeList.indexOf(id);
			if (i == -1)
			{
				return true;
			}
			
			if (id != UIFormID.UINpcTalk && (this.isFormVisible(UIFormID.UINpcTalk) && !m_bOpenFromInNpcTalkEnd))
			{
				var str:String = "打开界面(" + id + m_dicIDToFormIDConstantName[id] + ")失败，因为正在执行脚本";
				DebugBox.info(str);
				return false;
			}
			
			exitOthers(id);
			
			return true;
		}
		
		public function createFormInGame(id:uint):Form
		{
			var ret:Form = getForm(id);
			if (ret == null)
			{
				ret = m_uiGgrForGame.createUI(id);
				ret.id = id;
				addForm(ret);
			}
			return ret;
		
		}
		
		public function exitOthers(id:uint):void
		{
			var k:int;
			var form:Form;
			for (k = 0; k < m_excludeList.length; k++)
			{
				if (m_excludeList[k] != id)
				{
					if (this.isFormVisible(m_excludeList[k] as uint))
					{
						form = this.getForm(m_excludeList[k] as uint);
						form.exit();
					}
				}
			}
		}
		
		/*
		 * 将form移动到指定层上，目前只是针对UIChat对象
		 * 先找到当前所在层，如果当前层包含此form，则直接返回；否则从当前层去掉此form
		 * 然后找到目的层（layer），将form放入此层
		 *
		 */
		public function switchFormToLayer(form:Form, layerID:int):void
		{
			var i:int;
			var uiLayer:UILayer = form.uiLayer;
			if (uiLayer.layerID == layerID)
			{
				return;
			}
			form.uiLayer = vecLayer[layerID];
		}
		
		public function addToZeroLayer(dc:DisplayObject):void
		{
			if (dc.parent != m_zeroLayer)
			{
				m_zeroLayer.addChild(dc);
			}
		}
		
		// 这一层只有在过场景或者加载资源的时候使用，不用的时候直接移除掉
		public function addToTopMoseLayer(dc:DisplayObject):void
		{
			if (dc.parent != m_topMostLayer)
			{
				m_topMostLayer.addChild(dc);
			}
		}
		
		// 这一层只有在过场景或者加载资源的时候使用，不用的时候直接移除掉
		public function removeFromTopMoseLayer(dc:DisplayObject):void
		{
			if (dc.parent == m_topMostLayer)
			{
				m_topMostLayer.removeChild(dc);
			}
		}
		
		protected function createFormIDConstantNameList():void
		{
			if (m_UIFormIDConstantNameList != null)
			{
				return;
			}
			m_UIFormIDConstantNameList = new Vector.<String>();
			m_dicIDToFormIDConstantName = new Dictionary();
			var xml:XML = describeType(UIFormID);
			var xmlList:XMLList = xml.child("constant");
			var item:XML;
			var name:String;
			for each (item in xmlList)
			{
				name = item.@name;
				m_UIFormIDConstantNameList.push(name);
				m_dicIDToFormIDConstantName[UIFormID[name]] = name;
			}
		}
		
		public function getFormName(id:uint):String
		{
			return m_dicIDToFormIDConstantName[id];
		}
		
		//每10分钟调用一次
		public function onTimeUpdate():void
		{
			var layer:UILayer;			
			for each(layer in vecLayer)
			{
				layer.m_closeReguarlyProcessed = false;
			}
			
			m_gkcontext.m_context.m_idleTimeProcessMgr.insertProcess(this);
		}
		
		public function process():void
		{
			var bProcessed:Boolean;
			var layer:UILayer;			
			for each(layer in vecLayer)
			{
				if (layer.m_closeReguarlyProcessed)
				{
					continue;
				}
				if (layer.closeFormRegularly() == false)
				{
					layer.m_closeReguarlyProcessed = true;
				}
				else
				{
					//1次只处理1个
					bProcessed = true;
					break;
				}
			}
			if (bProcessed == false)
			{
				m_gkcontext.m_context.m_idleTimeProcessMgr.deleteProcess(this);
			}
		}
		
		// 仅仅加载 form 对应的 swf ，并不放在 Form 的管理器中
		public function loadFormOnlySwf(ID:uint):void
		{
			var path:String = m_gkcontext.m_UIPath.getPath(ID);
			m_path2ID[path] = ID;
			
			var res:SWFResource = m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource) as SWFResource; // 检查资源是否加载
			var uiRes:UIResourceLoading = m_UIResDic[path];
			if (!res) // 如果资源没有加载
			{
				var ad:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
						var lc:LoaderContext = new LoaderContext();
						lc.applicationDomain = ad;
				// 加载资源
				m_gkcontext.m_context.m_resMgr.load(path, SWFResource, onloadedSWFOnlySwf, onFailedSWFOnlySwf, onProgressSWF, onStartedSWF, false, lc);
			}
		}
		
		// 仅仅加载 swf ，不构建 form 的资源加载完成回调过程
		public function onloadedSWFOnlySwf(event:ResourceEvent):void
		{
			Logger.info(null, null, "Loaded " + event.resourceObject.filename);
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWFOnlySwf);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWFOnlySwf);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			// 加载进度条
			// 加载进度条
			if (m_gkcontext.m_context.progLoading.isVisible())
			{
				m_gkcontext.m_context.progLoading.progResLoaded(event.resourceObject.filename);
			}
			else
			{
				m_gkcontext.m_UIs.circleLoading.circleResLoaded(event.resourceObject.filename);
			}
		}
		
		// 资源加载失败，通过事件回调
		private function onFailedSWFOnlySwf(event:ResourceEvent):void
		{
			Logger.info(null, null, "Failed " + event.resourceObject.filename);
			// 移出事件处理
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onloadedSWFOnlySwf);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWFOnlySwf);
			event.resourceObject.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgressSWF);
			event.resourceObject.removeEventListener(ResourceEvent.STARTED_EVENT, onStartedSWF);
			
			// 加载进度条
			if (m_gkcontext.m_context.progLoading.isVisible())
			{
				m_gkcontext.m_context.progLoading.progResFailed(event.resourceObject.filename);
			}
			else
			{
				m_gkcontext.m_UIs.circleLoading.circleResFailed(event.resourceObject.filename);
			}
		}
		
		// 加载立即使用模块资源
		public function loadAllFormImm():void
		{
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIRadar));
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UITip));
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIChat));
			
			var formChat:Form = createFormInGame(UIFormID.UIChat);
			formChat.show();
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UiSysBtn);
			//loadForm(UIFormID.UIRadar);
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIHero);			
			loadForm(UIFormID.UITip);
			//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIScreenBtn);
		}
		
		// 提前加载的 form 对应的 swf ,并不构造对应的 form
		public function loadAllFormOnlySwf():void
		{
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UiSysBtn)); // 右下角系统按钮
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIHero)); // 角色按钮
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIScreenBtn)); // 屏幕中间按钮			
			
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIEquipSys)); // 锻造
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIZhenfa)); // 阵法
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIFndLst)); // 好友
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UICorpsMgr)); // 军团
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIMail)); // 邮件
			
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIGiftPack)); // 在线礼包
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIXuanShangRenWu)); // 悬赏任务
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIBarrierZhenfa)); // 精英 boss
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UICangbaoku)); // 藏宝库
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIJiuGuan)); // 酒馆
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIGuoguanzhanjiang)); // 过关斩将
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIIngotBefall)); // 财神降临
			m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UISceneTran)); // 过场景动画		
			
			//loadFormOnlySwf(UIFormID.UiSysBtn); // 右下角系统按钮
			//loadFormOnlySwf(UIFormID.UIHero); // 角色按钮
			//loadFormOnlySwf(UIFormID.UIScreenBtn); // 屏幕中间按钮			
			
			loadFormOnlySwf(UIFormID.UIEquipSys); // 锻造
			//loadFormOnlySwf(UIFormID.UIZhenfa); // 阵法
			loadFormOnlySwf(UIFormID.UIFndLst); // 好友
			loadFormOnlySwf(UIFormID.UICorpsMgr); // 军团
			loadFormOnlySwf(UIFormID.UIMail); // 邮件
			
			loadFormOnlySwf(UIFormID.UIGiftPack); // 在线礼包
			loadFormOnlySwf(UIFormID.UIXuanShangRenWu); // 悬赏任务
			loadFormOnlySwf(UIFormID.UIBarrierZhenfa); // 精英 boss
			loadFormOnlySwf(UIFormID.UICangbaoku); // 藏宝库
			loadFormOnlySwf(UIFormID.UIJiuGuan); // 酒馆
			loadFormOnlySwf(UIFormID.UIGuoguanzhanjiang); // 过关斩将
			loadFormOnlySwf(UIFormID.UIIngotBefall); // 财神降临
			loadFormOnlySwf(UIFormID.UISceneTran); // 过场景动画		
		}
		
		// 加载角色选择的时候资源
		public function loadHeroSel():void
		{
			//m_gkcontext.progLoadingaddResName(m_gkcontext.m_UIPath.getPath(UIFormID.UIHeroSelectNew)); // 角色选择
			//m_gkcontext.progLoadingaddResName("asset/uiimage/ani/ejxianhe.swf"); // 飞行的仙鹤资源
			//m_gkcontext.progLoadingaddResName("asset/uiimage/ani/ejjianjiaosexuanzhong.swf");
			//m_gkcontext.progLoadingaddResName("asset/uiimage/ani/ejjianjiaosejianru.swf");
			
			//loadFormOnlySwf(UIFormID.UIHeroSelectNew); // 角色选择
			//m_gkcontext.m_context.m_resMgr.load("asset/uiimage/ani/ejxianhe.swf", SWFResource, onloadedSWFOnlySwf, onFailedSWFOnlySwf, onProgressSWF, onStartedSWF);
			//m_gkcontext.m_context.m_resMgr.load("asset/uiimage/ani/ejjianjiaosexuanzhong.swf", SWFResource, onloadedSWFOnlySwf, onFailedSWFOnlySwf, onProgressSWF, onStartedSWF);
			//m_gkcontext.m_context.m_resMgr.load("asset/uiimage/ani/ejjianjiaosejianru.swf", SWFResource, onloadedSWFOnlySwf, onFailedSWFOnlySwf, onProgressSWF, onStartedSWF);
			
			// 开始加载 CG 动画
			//loadForm(UIFormID.UICGIntro);
		}
		
		// 只有第一次进入游戏的时候才会加载
		public function load1000SceneRes():void
		{
			m_gkcontext.progLoadingaddResName("asset/uiimage/ani/ejjiaosechuifei.swf");
			m_gkcontext.m_context.m_resMgr.load("asset/uiimage/ani/ejjiaosechuifei.swf", SWFResource, onloadedSWFOnlySwf, onFailedSWFOnlySwf, onProgressSWF, onStartedSWF);
		}
		
		public function get isGameUIInit():Boolean
		{
			return m_uiGgrForGame != null;
		}
		
		public function resetGameUIEvent():void
		{
			m_gkcontext.m_cbUIEvent = m_gameCBUIEvent;
		}
	}
}