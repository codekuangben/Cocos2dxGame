package modulecommon.ui.uiprog
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.IBarInProgress;
	import com.dgrigg.image.CommonImageManager;
	//import com.gskinner.motion.easing.Back;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	//import flash.utils.clearInterval;
	//import flash.utils.setInterval;
	
	import modulecommon.GkContext;
	//import modulecommon.time.Daojishi;
	import modulecommon.ui.Form;
	
	/**
	 * ...
	 * @author ...
	 * @brief 加载进度条
	 */
	public class ComProgBarLoading extends PanelContainer implements IBarInProgress
	{
		private var m_gkContext:GkContext;
		
		public var m_blackBG:Panel;
		public var m_prog:Panel;// 进度条
		public var m_frame:Panel;	// 边框
		public var m_eff:Panel;	// 特效
		
		protected var _value:Number = 0;		// 进度条显示比例当前数值
		protected var _pixelvalue:uint = 0;	// 进度条像素值
		protected var _max:Number = 1;			// 进度条显示比例最大数值
		protected var _progLen:uint = 550;		// 进度条的显示长度
		protected var _progpixelvalue:uint = 0;	// 渐进值，动画表现，移动到当前值的像素
		protected var _progdestpixel:uint = 0;		// 进度条可以到达的位置
		
		protected var _effBasePos:int = -24;	// 特效基础值
		//protected var m_daojishi:Daojishi;		// 进度表现
		protected var m_timeID:uint;				// 定时器 ID
		public var m_parForm:Form;
		
		public function ComProgBarLoading(cnt:GkContext)
		{
			m_gkContext = cnt;
			
			m_blackBG = new Panel(this, 0, 0);
			m_blackBG.setSize(_progLen + 2 * 37, 42);
			m_blackBG.autoSizeByImage = false;
			m_blackBG.alpha = 0.7;
			m_blackBG.setPanelImageSkin("commoncontrol/panel/blackbg.jpg");
			
			m_prog = new Panel(this, 37, 11);
			m_prog.setSize(1, 18);
			m_prog.autoSizeByImage = false;
			//m_prog.cacheAsBitmap = true;
			
			m_frame = new Panel(this, 0, 0);
			m_frame.setSize(_progLen + 2 * 37, 42);
			m_frame.autoSizeByImage = false;
			m_frame.cacheAsBitmap = true;
			
			m_eff = new Panel(this, _effBasePos, -8);
			m_eff.setSize(83, 52);
			m_eff.autoSizeByImage = false;
			m_eff.cacheAsBitmap = true;
			
			// 加载资源
			//m_gkContext.m_context.m_resMgr.load(CommonImageManager.toPathString("commoncontrol/progress/progressloading.swf"), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			
			// 设置这个控件的大小
			this.setSize(_progLen + 2 * 37, 42);
			
			//m_daojishi = new Daojishi(m_gkContext.m_context);
		}
		
		public function loadRes():void
		{
			m_gkContext.m_context.m_resMgr.load(CommonImageManager.toPathString("commoncontrol/progress/progressloading.swf"), SWFResource, onImageSwfLoaded, onImageSwfFailed);
		}
		
		override public function dispose():void
		{
			super.dispose();
			//m_daojishi.dispose();
		}
		public function set initValue(v:Number):void
		{
			
		}
		
		public function initBar():void
		{
			
		}
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onImageSwfLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onImageSwfFailed);
			
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			
			Logger.info(null, null, event.resourceObject.filename + " Loaded");
			m_gkContext.m_context.m_resMgr.unload(CommonImageManager.toPathString("commoncontrol/progress/progressloading.swf"), SWFResource);
		}
		
		private function onImageSwfFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onImageSwfLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onImageSwfFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " Failed");
			m_gkContext.m_context.m_resMgr.unload(CommonImageManager.toPathString("commoncontrol/progress/progressloading.swf"), SWFResource);
		}
		
		private function createImage(res:SWFResource):void
		{
			m_prog.setPanelImageSkinBySWF(res, "progressloading.bottom");
			m_frame.setHorizontalImageSkinBySWF(res, "progressloading.frame_mirror");
			m_eff.setPanelImageSkinBySWF(res, "progressloading.effect");
		}
		
		// 渐进的方法去掉
		/*
		public function set maximum(m:Number):void
		{
			_max = m;
			
			// 设置当前可以达到的距离
			_progdestpixel = (1 / _max) * _progLen;
		}
		
		public function set value(v:Number):void
		{
			if (_value == v)
			{
				return;
			}
			//_progpixelvalue = (_value / _max) * _progLen;
			_value = v;
			_pixelvalue = (_value / _max) * _progLen;
			
			if(_value < _max)
			{
				if(_max > 1)
				{
					_progdestpixel = ((_value + 1) / _max) * _progLen;
				}
				else
				{
					if(_value == 0)
					{
						_progpixelvalue = (_value / _max) * _progLen;
					}
					_progdestpixel = _progLen;
				}
			}
			
			// 如果没有定时器，直接设置
			//if(!m_bTime)
			//{
				// 更新进度条位置
				//m_prog.setSize(_pixelvalue, 18);
				// 立即重新绘制，否则会闪烁
				//m_prog.draw();
				// 更新特效位置
				//m_eff.x = _effBasePos + _pixelvalue;	
			//}
		}
		
		//单位毫秒
		public function beginDaojishi(leftTime:int):void
		{
			//m_daojishi.funCallBack = updateDaojishi;
			//m_daojishi.initLastTime = leftTime;
			//m_daojishi.begin();
			
			m_timeID = setInterval(updateDaojishi, 20);
		}
		
		//public function updateDaojishi(d:Daojishi):void
		public function updateDaojishi():void
		{
			if(_progpixelvalue < _progdestpixel)
			{
				if(_max > 1)
				{
					if(_progpixelvalue < _pixelvalue)
					{
						_progpixelvalue += 200;
					}
					else
					{
						_progpixelvalue += 1;
					}
				}
				else
				{
					if(_progpixelvalue < _pixelvalue)
					{
						_progpixelvalue = _pixelvalue;
					}
					else
					{
						_progpixelvalue += 1;
					}
				}
				
				if(_progpixelvalue > _progdestpixel)
				{
					_progpixelvalue = _progdestpixel;
				}
				
				// 更新进度条位置
				m_prog.setSize(_progpixelvalue, 18);
				// 立即重新绘制，否则会闪烁
				m_prog.draw();
				// 更新特效位置
				m_eff.x = _effBasePos + _progpixelvalue;
			}
			else if(_value == _max)
			{
				//m_daojishi.end();
				//m_daojishi.funCallBack = null;
				clearInterval(m_timeID);
				if(m_parForm)
				{
					m_parForm.exit();
				}
			}
		}
		*/
		
		// 改成直接到具体位置
		public function set maximum(m:Number):void
		{
			_max = m;
		}
		
		public function set value(v:Number):void
		{
			if (_value == v)
			{
				return;
			}
			
			_value = v;
			_progpixelvalue = (_value / _max) * _progLen;
			
			updateDaojishi();
		}

		public function updateDaojishi():void
		{
			//if(_value < _max)
			//{				
				// 更新进度条位置
				m_prog.setSize(_progpixelvalue, 18);
				// 立即重新绘制，否则会闪烁
				m_prog.draw();
				// 更新特效位置
				m_eff.x = _effBasePos + _progpixelvalue;
			//}
			//else if(_value == _max)
			if(_value == _max)
			{
				if(m_parForm)
				{
					m_parForm.exit();
				}
			}
		}
	}
}