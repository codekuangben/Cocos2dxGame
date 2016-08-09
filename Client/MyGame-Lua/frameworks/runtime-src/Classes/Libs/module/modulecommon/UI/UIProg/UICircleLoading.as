package modulecommon.ui.uiprog
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import modulecommon.ui.Form;
	import flash.display.Shape;
	import modulecommon.ui.UIFormID;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.debug.Logger;
	import com.bit101.components.TextNoScroll;
	import flash.text.TextFieldAutoSize;
	
	import com.util.UtilColor;
	import com.util.UtilHtml;

	/**
	 * @brief 运行中加载一个资源需要显示的功能
	 * */
	public class UICircleLoading extends Form
	{
		protected static const TotalAngle:uint = 8;	// 总共的角度，第一个角度是 90 度的
		
		protected var m_bg:Shape;
		protected var m_circleCont:DisplayObjectContainer;
		protected var m_loadingRes:Vector.<String>;	// 要加载的资源
		protected var m_timeID:uint;					// 定时器 ID
		protected var m_bmd:BitmapData;				// 旋转的小图资源
		
		protected var m_angleList:Vector.<ComCircleAngle>;
		protected var m_rotateDegree:int;
		protected var m_desc:TextNoScroll;		// 加载进度描述
		
		public function UICircleLoading()
		{
			this.id = UIFormID.UICircleLoading;
		}
		
		override public function onReady():void
		{
			exitMode = EXITMODE_HIDE;
			hideOnCreate = true;
			
			m_bg = new Shape();
			this.addChild(m_bg);
			
			m_circleCont = new Sprite();
			this.addChild(m_circleCont);

			m_desc = new TextNoScroll();
			this.addChild(m_desc);
			m_desc.autoSize = TextFieldAutoSize.LEFT;
			m_desc.wordWrap = false;
			m_desc.multiline = false;
			
			m_loadingRes = new Vector.<String>();
			m_angleList = new Vector.<ComCircleAngle>(TotalAngle, true);
			
			m_rotateDegree = 0;
			//this.m_gkcontext.m_context.m_resMgr.load("asset/uiimage/commoncontrol/progress/circleloading.swf", SWFResource, onResLoaded, onResFailed);
			super.onReady();
		}
		
		public function loadSwfRes():void
		{
			this.m_gkcontext.m_context.m_resMgr.load("asset/uiimage/commoncontrol/progress/circleloading.swf", SWFResource, onResLoaded, onResFailed);
		}
		
		override public function onShow():void
		{
			m_timeID = setInterval(repeatCB, 200);

			onStageReSize();
			
			// 调整位置，这个 UI 所在的层的位置，可能这个时候加载进度条正在显示
			if (this.parent.numChildren > 1)
			{
				this.parent.addChildAt(this, 0);
			}
			
			// 设置最初的值
			updateDesc("", 0);
		}
		
		override public function onStageReSize():void
		{
			// 绘制背景
			m_bg.graphics.clear()
			m_bg.graphics.beginFill(0x000000, 0.3);
			m_bg.graphics.drawRect(0, 0, m_gkcontext.m_context.m_config.m_curWidth, m_gkcontext.m_context.m_config.m_curHeight);
			m_bg.graphics.endFill();
			
			// 调整位置
			m_circleCont.x = m_gkcontext.m_context.m_config.m_curWidth/2;
			m_circleCont.y = m_gkcontext.m_context.m_config.m_curHeight/2;
			
			m_desc.x = (m_gkcontext.m_context.m_config.m_curWidth - m_desc.width)/2;
			m_desc.y = (m_gkcontext.m_context.m_config.m_curHeight - m_desc.height)/2;
		}
		
		override public function onHide():void
		{
			clearInterval(m_timeID);
		}
		
		override public function onDestroy():void
		{
			m_gkcontext.m_UIs.circleLoading = null;
		}
		
		public function loadRes(path:String):void
		{
			if(m_loadingRes.indexOf(path) == -1)
			{
				Logger.info(null, null, "添加加载进度特效:" + path);
				m_loadingRes.push(path);
				if(!this.isVisible())
				{
					show();
				}
			}
		}
		
		// 资源加载成功
		public function circleResLoaded(path:String):void
		{
			resHandle(path);
		}
		
		// 资源加载失败
		public function circleResFailed(path:String):void
		{
			resHandle(path);
		}
		
		protected function resHandle(path:String):void
		{
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				m_loadingRes.splice(residx, 1);
				
				if(!m_loadingRes.length)
				{
					exit();
				}
			}
		}
		
		// 定时器回调函数
		protected function repeatCB():void
		{
			m_rotateDegree += 360 / TotalAngle;
			m_rotateDegree %= 360;
			m_circleCont.rotation = m_rotateDegree;
		}
		
		// 资源加载成功     
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			m_bmd = (event.resourceObject as SWFResource).getExportedAsset("art.circleloading.angle") as BitmapData;
			
			// 实例化数据
			var idx:uint = 0;
			while (idx < TotalAngle)
			{
				m_angleList[idx] = new ComCircleAngle(m_bmd, 360 / TotalAngle * idx);
				m_angleList[idx].alpha = idx/(TotalAngle - 1);
				m_circleCont.addChild(m_angleList[idx]);
				++idx;
			}
			
			this.m_gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			Logger.info(null, null, event.resourceObject.filename + " loaded");
		}
		
		// 资源加载失败    
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			this.m_gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			Logger.info(null, null, event.resourceObject.filename + " failed");
		}
		
		// 资源进度
		public function progResProgress(path:String, percent:Number):void
		{
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				updateDesc(path, Number(percent.toFixed(2)) * 100);
			}
		}
		
		// 资源开始
		public function progResStarted(path:String):void
		{
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				updateDesc(path, 0);
			}
		}
		
		// 更新资源加载的进度显示
		public function updateDesc(path:String, percent:Number):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add(int(percent) + "%", UtilColor.GREEN, 12);	
			m_desc.htmlText = UtilHtml.getComposedContent();
			
			m_desc.x = (m_gkcontext.m_context.m_config.m_curWidth - m_desc.width)/2;
			m_desc.y = (m_gkcontext.m_context.m_config.m_curHeight - m_desc.height)/2;
		}
		
		public function clearDesc():void
		{
			m_desc.htmlText = "";
		}
	}
}