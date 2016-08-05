package start 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * @brief 一个进度条
	 */
	public class ProgCom extends Sprite
	{
		protected var m_loaderProg:Loader;			// 加载进度条 swf
		protected var m_bprogLoaded:Boolean;		// 是否加载完成
		protected var m_appDomain:ApplicationDomain;
		
		// 就一个进度条
		// 进度条底图
		protected var m_bgBM:Bitmap;
		protected var m_bgBMD:BitmapData;
		// 进度条边框
		protected var m_leftBitmap:Bitmap;		//左半部分
		protected var m_centerBitmap:Bitmap;	//中间部分
		protected var m_rightBitmap:Bitmap;		//右半部分
		
		protected var m_LeftData:BitmapData; 	//左部分
		protected var m_CenterData:BitmapData; 	//中间部分
		protected var m_RightData:BitmapData; 	//右部分
		// 进度条当前位置图标
		protected var m_curIconBM:Bitmap;
		protected var m_curIconBMD:BitmapData;

		protected var m_prog:Sprite;
		protected var m_frame:Sprite;
		protected var m_eff:Sprite;
		
		protected var m_progLen:uint = 550;		// 进度条的显示长度
		protected var m_effBasePos:int = -24;	// 特效基础值
		public var m_selfWidth:uint;
		public var m_selfHeight:uint;
		
		protected var m_baseURL:String;
		protected var m_curPos:Number;
		
		protected var m_loadingRes:Vector.<String>;	// 将要加载的资源
		protected var m_loadedRes:Vector.<String>;	// 已经加载成功的资源
		protected var m_failedRes:Vector.<String>;	// 已经加载失败的资源
		protected var m_descLst:Vector.<String>;	// 加载的描述
		
		protected var m_totaldesc:TextField;		// 所有文件的描述加载信息
		public var m_disposeCB:Function;

		public function ProgCom(baseurl:String) 
		{
			m_baseURL = baseurl;
			
			m_prog = new Sprite();
			this.addChild(m_prog);
			m_prog.x = 37;
			m_prog.y = 11;
			
			m_frame = new Sprite();
			this.addChild(m_frame);

			m_eff = new Sprite();
			this.addChild(m_eff);
			m_eff.x = m_effBasePos;
			m_eff.y = -8;
			
			m_totaldesc = new TextField();
			this.addChild(m_totaldesc);
			m_totaldesc.autoSize = TextFieldAutoSize.CENTER;
			m_totaldesc.wordWrap = false;
			m_totaldesc.multiline = false;
			m_totaldesc.textColor = 0x00ff00;
			m_totaldesc.text = "(若无加载请刷新再试)";

			//this.width = m_progLen + 2 * 37;
			//this.height = 42;
			m_selfWidth = m_progLen + 2 * 37;
			m_selfHeight = 42;
			
			m_totaldesc.x = m_selfWidth/2;
			m_totaldesc.y = 30;
			
			//this.graphics.beginFill(0xff0000);
			//this.graphics.drawRect(0, 0, 100, 100);
			//this.graphics.endFill();
			//return;
			
			m_loadingRes = new Vector.<String>();
			m_loadedRes = new Vector.<String>();
			m_failedRes = new Vector.<String>();
			m_descLst = new Vector.<String>();
			
			m_loadingRes.push("asset/module/ModuleApp.swf");
			m_descLst.push("加载代码主模块");
			m_loadingRes.push("asset/versionall.swf");
			m_descLst.push("加载版本文件");
			//m_loadingRes.push("asset/uiimage/commonswf/commonimage.swf");
			//m_descLst.push("加载界面基本资源");
			//m_loadingRes.push("asset/scene/replace/replace.swf");
			//m_descLst.push("加载场景占位资源");			
			//m_loadingRes.push("asset/config/Base.txt");
			//m_descLst.push("加载基本配置文件");

			updateLabel();
			loadProg();
		}
		
		protected function dispose():void
		{
			if (m_disposeCB)
			{
				m_disposeCB();
				m_disposeCB = null;
			}
			
			if (m_bgBMD)
			{
				m_bgBMD.dispose();
				m_bgBMD = null;
			}
			if (m_LeftData)
			{
				m_LeftData.dispose();
				m_LeftData = null;
			}
			if (m_CenterData)
			{
				m_CenterData.dispose();
				m_CenterData = null;
			}
			if (m_RightData)
			{
				m_RightData.dispose();
				m_RightData = null;
			}
			if (m_curIconBMD)
			{
				m_curIconBMD.dispose();
				m_curIconBMD = null;
			}
		}
		
		// 加载进度条资源
		public function loadProg():void
		{
			m_loaderProg = new Loader();
			m_loaderProg.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandlerProg);
			m_loaderProg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandlerProg);

			var serverpath:String;		// 服务器 url，例如 http://192.168.1.205/test/
			var slashidx:int;
			slashidx = m_baseURL.lastIndexOf("/");
			serverpath = m_baseURL.substring(0, slashidx + 1);
			var url:URLRequest = new URLRequest(serverpath + "asset/uiimage/commoncontrol/progress/progressloading.swf?v=" + new Date().toString() + Math.random());
			m_loaderProg.load(url);
		}
		
		public function onCompleteHandlerProg(evt:Event):void 
		{
			m_bprogLoaded = true;
			try
			{
				var assetClass:Class = null;
				var bmd:BitmapData;
				var name:String;
				var sourceRect:Rectangle;
				var desPoint:Point;
				
				m_appDomain = m_loaderProg.contentLoaderInfo.applicationDomain;

				// 获取底图
				//if (m_appDomain.hasDefinition(name))
				//{
					//assetClass = m_appDomain.getDefinition(name) as Class;
					//if(assetClass)
					//{
					//	bmd = new assetClass() as BitmapData;
					//}
				//}
				name = "art.progressloading.bottom";
				assetClass = m_appDomain.getDefinition(name) as Class;
				bmd = new assetClass() as BitmapData;
				m_bgBMD = bmd.clone();
				// 获取进度条
				name = "art.progressloading.frame_mirror";
				assetClass = m_appDomain.getDefinition(name) as Class;
				bmd = new assetClass() as BitmapData;
				// 左边
				sourceRect = new Rectangle(0, 0, bmd.width - 1, bmd.height);
				desPoint = new Point(0, 0);
				
				m_LeftData = new BitmapData(sourceRect.width, sourceRect.height);
				m_LeftData.copyPixels(bmd, sourceRect, desPoint);
				// 中间
				sourceRect.x = sourceRect.width;
				sourceRect.width = 1;
				m_CenterData = new BitmapData(sourceRect.width, sourceRect.height);
				m_CenterData.copyPixels(bmd, sourceRect, desPoint);
				// 右边
				m_RightData = flipBitmapDataHori(m_LeftData);
				// 获取进度条当前位置图标
				name = "art.progressloading.effect";
				assetClass = m_appDomain.getDefinition(name) as Class;
				bmd = new assetClass() as BitmapData;
				m_curIconBMD = bmd.clone();
				
				// 释放资源
				assetClass = null;
				m_appDomain = null;
				m_loaderProg.unloadAndStop();
				m_loaderProg = null;
				
				updateBitmapdata();
			}
			catch (e:SecurityError)
			{
				
			}
		}
		
		public function onErrorHandlerProg(evt:ErrorEvent) : void
		{
			if(!m_bprogLoaded)		// m_loaderProg.unloadAndStop(); 这一行有几率触发 IOErrorEvent.IO_ERROR 这个事件
			{
				trace("Failed On Loading progressloading.swf");
			}
		}
		
		//横向镜像
		public static function flipBitmapDataHori(data:BitmapData):BitmapData
		{
			var buffer:BitmapData = new BitmapData(data.width, data.height, data.transparent, 0);
			var rect:Rectangle = new Rectangle(0, 0, 1, data.height);
			var destP:Point = new Point(data.width - 1, 0);
			
			for (var i:int = 0; i < data.width; i++)
			{
				buffer.copyPixels(data, rect, destP);
				rect.x ++;
				destP.x--;
			}
			return buffer;
		}
		
		// 更新显示数据
		protected function updateBitmapdata():void
		{
			// 添加显示
			m_bgBM = new Bitmap(m_bgBMD);
			m_prog.addChild(m_bgBM);
			m_leftBitmap = new Bitmap(m_LeftData);
			m_frame.addChild(m_leftBitmap);
			m_centerBitmap = new Bitmap(m_CenterData);
			m_frame.addChild(m_centerBitmap);
			m_rightBitmap = new Bitmap(m_RightData);
			m_frame.addChild(m_rightBitmap);
			m_curIconBM = new Bitmap(m_curIconBMD);
			m_eff.addChild(m_curIconBM);
			
			// 更新位置
			var widthCenter:int;
			//widthCenter = this.width - m_leftBitmap.width - m_rightBitmap.width;
			widthCenter = this.m_selfWidth - m_leftBitmap.width - m_rightBitmap.width;
			m_centerBitmap.width = widthCenter;
			m_centerBitmap.x = m_LeftData.width;
			m_rightBitmap.x = m_leftBitmap.width + m_centerBitmap.width;
			
			updateProg(m_curPos);
		}
		
		// 更新进度条位置
		public function updateProg(curpos:Number):void
		{
			m_curPos = curpos;
			if (m_bprogLoaded)
			{
				var curlen:uint = m_progLen * curpos;
				m_bgBM.width = curlen;
				m_curIconBM.x = curlen;
			}
		}
		
		public function progResLoaded(path:String):void
		{
			if (m_loadedRes.indexOf(path) == -1)
			{
				m_loadedRes.push(path);
			}
			
			// 计算更新进度
			updateProg((m_loadedRes.length + m_failedRes.length) / m_loadingRes.length);
			updateLabel();
			checkDispose();
		}

		public function progResProgress(path:String, percent:Number):void
		{
			// 计算更新进度
			updateProg((m_loadedRes.length + m_failedRes.length) / m_loadingRes.length + 1 / m_loadingRes.length * percent);
		}
		
		public function progResFailed(path:String):void
		{
			if (m_failedRes.indexOf(path) == -1)
			{
				m_failedRes.push(path);
			}
			
			// 计算更新进度
			updateProg((m_loadedRes.length + m_failedRes.length) / m_loadingRes.length);
			updateLabel();
			checkDispose();
		}
		
		protected function checkDispose():void
		{
			// 移除判断
			if (m_loadedRes.length + m_failedRes.length == m_loadingRes.length)
			{
				dispose();
			}
		}
		
		protected function updateLabel():void
		{
			if (m_loadedRes.length + m_failedRes.length < m_loadingRes.length)
			{
				m_totaldesc.text = m_descLst[m_loadedRes.length + m_failedRes.length] + "(若无加载请刷新再试)";
			}
		}
	}
}