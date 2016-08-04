package start
{
	//import flash.display.Bitmap;
	//import flash.display.Bitmap;
	//import flash.display.BitmapData;
	import base.IModuleApp;
	import base.IStart;
	import base.IVersionAllInfo;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	//[SWF(width="1300", height="568", frameRate="30", backgroundColor="0x999999")]
	//[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x000000")]
	[SWF(frameRate="30", backgroundColor="0x000000")]
	public class Start extends Sprite implements IStart
	{
		protected var _loaderApp : Loader;
		protected var _loaderVer : Loader;
		//protected var _loaderLogo : Loader;
		protected var _appDomain:ApplicationDomain;
		//protected var _bytesTotal : int = -1;
        //protected var _bytesLoaded : int = 0;
		
		//protected var _bytesRemaining : int = 10000000;
        //protected var _percentLoaded : Number;
		protected var _appVer:String = "";		// 这个是 app 版本的信息
		protected var _startPicVer:String = "";		// 这个是启动图片的版本的信息
		public var _versionAllVer:String = "";		// 这个是整个版本文件的版本信息
		protected var _bappVersionLoaded:Boolean = false;		// versionapp.swf 这个资源是否被成功加载
		//protected var _bLogoLoaded:Boolean = false;				// uiloadinglogo.swf 这个资源是否被成功加载
		
		//protected var _bitmap:Bitmap;						// 显示 logo 用的
		//protected var _image:Bitmap;
		
		//[Embed(source="../../../../assets/pic/bg.PNG")]
		//private var m_picClass:Class;
		protected var m_UncaughtErrorHandler:Function;
		protected var m_moduleApp:IModuleApp;
		protected var m_startUI:UIStart;
		protected var m_versionAll:VersionAllInfo;
		protected var m_log:String="";
		public function Start():void 
		{
			if (stage) 
			{
				setStyle();
				init();
				
				//this.graphics.beginFill(0xff0000);
				//this.graphics.drawRect(0, 0, 100, 100);
				//this.graphics.endFill();
			}
		}

		public function onUncaughtErrorHappened(event:UncaughtErrorEvent):void
		{
			if (m_UncaughtErrorHandler != null)
			{
				m_UncaughtErrorHandler(event);
			}
			/*var message:String;
             
             if (event.error is Error)
             {
				 var error:Error = (event.error) as Error;
                 message = error.message+error.getStackTrace();
             }
           
             else
             {
                 message = event.error.toString();
             }*/			 
		}
		private function init(e:Event = null):void 
		{
			//if (ExternalInterface.available)
			//{
				//ExternalInterface.call("change");
			//}
			
			//stage.stageWidth = 1280;
			//stage.stageHeight = 800;
			addLog("Start::init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			m_startUI = new UIStart(this.loaderInfo.url);
			this.addChild(m_startUI);
			m_startUI.postInit();
			m_startUI.m_progBarLoading.m_disposeCB = disposeCB;
			
			//_image = new m_picClass();
			//this.addChild(_image);
			//_bitmap = new Bitmap();
			//this.addChild(_bitmap);
			
			//this.stage.addEventListener(Event.RESIZE, onResize);
			loadAppVer();
			//onResize();
		}
		
		// 窗口重新设置大小
		//public function onResize(event:Event = null):void
		//{
		//	// 居中显示
		//	_bitmap.x = (this.stage.stageWidth - 291)/2 - 250;
		//	_bitmap.y = (this.stage.stageHeight - 212)/2 - 110;
		//}
		
		// 加载 ModuleApp versionall 和 logo 的版本信息 
		public function loadAppVer():void
		{
			_loaderVer = new Loader();
			//_loaderVer.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandlerVer);
			_loaderVer.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandlerVer);
			_loaderVer.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandlerVer);
			
			//var url:URLRequest = new URLRequest("asset/versionapp.swf?v=" + int(Math.random()  * 100 * getTimer()));
			var serverpath:String;		// 服务器 url，例如 http://192.168.1.205/test/
			var slashidx:int;
			slashidx = this.loaderInfo.url.lastIndexOf("/");
			serverpath = this.loaderInfo.url.substring(0, slashidx + 1);
			var url:URLRequest = new URLRequest(serverpath + "asset/versionapp.swf?v=" + new Date().toString() + Math.random());
			_loaderVer.load(url);
		}
		
		// 加载 logo 资源
		//public function loadLogo():void
		//{
		//	_loaderLogo = new Loader();
			//_loaderLogo.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandlerLogo);
		//	_loaderLogo.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandlerLogo);
		//	_loaderLogo.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandlerLogo);

		//	var url:URLRequest = new URLRequest("asset/uiimage/loadinglogo/uiloadinglogo.swf?v=" + _startPicVer);
		//	_loaderLogo.load(url);
		//}
		
		public function loadApp():void
		{
			_loaderApp = new Loader();
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loaderApp.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loaderApp.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loaderApp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			
			var url:URLRequest = new URLRequest("asset/module/ModuleApp.swf?v=" + _appVer);
			_loaderApp.load(url);
		}
		
		public function onCompleteHandler(evt:Event) : void 
		{
			addLog("Start::onCompleteHandler ModuleApp Loaded");
        	try
			{
	            addChild(_loaderApp.content as Sprite);
				loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorHappened);
				m_moduleApp = _loaderApp.content as IModuleApp;
				//this.removeChild(_image);
				//_image.bitmapData.dispose();
				//_image = null;
				progResLoaded("asset/module/ModuleApp.swf");
				if (m_versionAll.loaded)
				{
					m_moduleApp.beginProcess();
				}
	        }
			catch (e : SecurityError)
			{
	        	
	        }
        }
		
		public function onErrorHandler(evt:ErrorEvent) : void
		{
            trace("Failed On Loading ModuleApp.swf");
        }
		
		public function onProgress(evt:ProgressEvent) : void 
		{
			progResProgress("asset/module/ModuleApp.swf", evt.bytesLoaded/evt.bytesTotal);
		}
		
		//public function onProgressHandler(evt : * ) : void 
		//{
        //   _bytesLoaded = evt.bytesLoaded;
        //   _bytesTotal = evt.bytesTotal;
        //   _bytesRemaining = _bytesTotal - _bytesLoaded;
        //   _percentLoaded = _bytesLoaded / _bytesTotal;
        //}
		
		public function onCompleteHandlerVer(evt:Event) : void 
		{
			
			_bappVersionLoaded = true;
			try
			{
				var assetClass:Class = null;
				var bytes:ByteArray;
				var name:String = "art.ver.app";
				
				_appDomain = _loaderVer.contentLoaderInfo.applicationDomain;

				if (_appDomain.hasDefinition(name))
					assetClass = _appDomain.getDefinition(name) as Class;
				if(assetClass)
				{
					bytes = new assetClass() as ByteArray;
					var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
					var linelist:Array = str.split("\n");

					var strlist:Array;
					strlist = linelist[0].split("=");
					_appVer = strlist[1].substr(0, strlist[1].length - 1);		// 去掉最后的空格
					
					strlist = linelist[1].split("=");
					_startPicVer = strlist[1].substr(0, strlist[1].length - 1);	// 去掉最后的空格
					
					strlist = linelist[2].split("=");
					_versionAllVer = strlist[1];
				}
				
				// 释放资源
				assetClass = null;
				bytes = null;
				_appDomain = null;
				_loaderVer.unloadAndStop();
				_loaderVer = null;
				
				loadApp();
				m_versionAll = new VersionAllInfo(this, _versionAllVer);
				m_versionAll.load();
				//loadLogo();
			}
			catch (e:SecurityError)
			{
				
			}
			addLog("Start::onCompleteHandler _versionAllVer="+_versionAllVer);
		}
		public function onVersionAllLoaded():void
		{
			progResLoaded("asset/versionall.swf");
			if (m_moduleApp)
			{
				m_moduleApp.beginProcess();
			}
		}
		public function onErrorHandlerVer(evt:ErrorEvent) : void
		{
			if(!_bappVersionLoaded)		// _loaderVer.unloadAndStop(); 这一行有几率触发 IOErrorEvent.IO_ERROR 这个事件
			{
				trace("Failed On Loading versionapp.swf");
			}
		}
		
		//public function onProgressHandlerVer(evt : * ) : void 
		//{
		//	
		//}
		
		//public function onCompleteHandlerLogo(evt : Event) : void 
		//{
		//	_bLogoLoaded = true;
		//	try
		//	{
		//		var assetClass:Class = null;
		//		var btdata:BitmapData;
		//		var name:String = "art.uiloading.logo";
				
		//		_appDomain = _loaderLogo.contentLoaderInfo.applicationDomain;
				
		//		if (_appDomain.hasDefinition(name))
		//			assetClass = _appDomain.getDefinition(name) as Class;
		//		if(assetClass)
		//		{
		//			btdata = new assetClass() as BitmapData;
		//		}
				
				// 释放资源
		//		assetClass = null;
		//		_appDomain = null;
		//		_loaderLogo.unloadAndStop();
		//		_loaderLogo = null;
				//onResize();
		//		_bitmap.bitmapData = btdata;
				
		//		loadApp();
		//	}
		//	catch (e : SecurityError)
		//	{
		//		
		//	}
		//}
		
		//public function onErrorHandlerLogo(evt : ErrorEvent) : void
		//{
		//	if(!_bLogoLoaded)		// _loaderLogo.unloadAndStop(); 这一行有几率触发 IOErrorEvent.IO_ERROR 这个事件
		//	{
		//		trace("Failed On Loading uiloadinglogo.swf");
		//	}
		//}
		
		//public function onProgressHandlerLogo(evt : * ) : void 
		//{
		//	
		//}
		
		public function setStyle():void
		{
			this.stage.align = StageAlign.TOP_LEFT;			// align: "top"    
			this.stage.scaleMode = StageScaleMode.NO_SCALE;	// scale: "noScale"
		}

		public function progResLoaded(path:String):void
		{
			if (m_startUI)
			{
				m_startUI.m_progBarLoading.progResLoaded(path);
			}
		}

		public function progResProgress(path:String, percent:Number):void
		{
			if (m_startUI)
			{
				m_startUI.m_progBarLoading.progResProgress(path, percent);
			}
		}
		
		public function progResFailed(path:String):void
		{
			if (m_startUI)
			{
				m_startUI.m_progBarLoading.progResFailed(path);
			}
		}
		
		public function disposeCB():void
		{
			if (m_startUI && this.contains(m_startUI))
			{
				this.removeChild(m_startUI);
				m_startUI = null;
			}
		}
		
		public function set uncaughtErrorHandler(fun:Function):void
		{
			m_UncaughtErrorHandler = fun;
		}
		
		public function get versionAllInfo():IVersionAllInfo
		{
			return m_versionAll;
		}
		
		public function addLog(log:String):void
		{
			m_log += getTimer() + " " + log+"\n";
		}
		
		public function getLog():String
		{
			return m_log;
		}
	}
}