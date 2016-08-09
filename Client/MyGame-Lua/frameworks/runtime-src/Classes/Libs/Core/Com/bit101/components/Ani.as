package com.bit101.components 
{
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageAni;
	import com.gskinner.motion.GTween;
	import com.util.DebugBox;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.ffilmation.engine.helpers.fUtil;
	//import com.pblabs.engine.core.IFrameStage;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.SWFResource;
	import common.event.UIEvent;
	//import flash.events.Event;
	
	import common.Context;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Ani extends Sprite
	{
		public static const INVALIDVALUE:int = 10000;
		private var m_loadState:int;
		private var m_gtWeen:GTween;
		private var m_aniName:String;
		private var m_imageAni:ImageAni;
		private var m_context:Context;
		private var m_bitmap:Bitmap;
		private var m_fFrame:Number;
		private var m_bStop:Boolean;
		private var m_funProgresscallBack:Function;		//m_funProgresscallBack与m_timeProgresscallBack是相互关联的两个对象
		private var m_timeProgresscallBack:Number;
		private var m_bCenterPlay:Boolean;	//将特效图片的中心点放在(0,0)位置播放
		private var m_bDisposed:Boolean;
		private var m_autoStopWhenHide:Boolean;		
		private var m_autoHideWhenComplete:Boolean;	//当动画播放完毕时，自动隐藏
		private var _tag:int;
		
		public var m_fcomp:Function;			// 特效播放完成调用这个函数
		public var m_fpreframe:Function;		// 在改变帧之前调用的会掉函数
		
		public var m_funOnFrameSpecified:Function;
		public var m_frameSpecified:Number;
		private var m_parent:DisplayObjectContainer;
		
		public function Ani(con:Context, parent:DisplayObjectContainer=null, xpos:Number = 0, ypos:Number = 0) 
		{
			m_context = con;
			m_parent = parent;
			if (m_parent)
			{
				m_parent.addChild(this);
			}
			this.x = xpos;
			this.y = ypos;
			
			m_gtWeen = new GTween();
			m_gtWeen.target = this;
			m_gtWeen.autoPlay = false;
			m_gtWeen.paused = true;
			m_gtWeen.onComplete = onComplete;
			m_bStop = true;			
			m_gtWeen.useFrames = false;
			m_bitmap = new Bitmap();
			addChild(m_bitmap);
			m_funProgresscallBack = null;
			m_timeProgresscallBack = 0;		
			m_bDisposed = false;
			tabEnabled = false;
		
		}
		
		public function show():void
		{
			if (m_parent)
			{
				if (m_parent != this.parent)
				{
					m_parent.addChild(this);
				}				
			}
		}
		
		public function hide():void
		{
			if (m_parent)
			{
				if (m_parent == this.parent)
				{
					m_parent.removeChild(this);
				}	
			}
		}
		public function setImageAni(res:String):void
		{
			clear();			
			m_loadState = Image.Loading;
			m_aniName = "ani/"+res;
			m_context.m_commonImageMgr.loadImage(m_aniName, ImageAni, onLoaded, onFailed);
		}
		
		public function setImageAniMirror(res:String, mode:String):void
		{
			clear();			
			m_aniName = "ani/"+res;
			m_context.m_commonImageMgr.loadModeImage(m_aniName, mode, ImageAni,onLoaded, onFailed);			
		}
		
		public function setImageAniBySWF(swf:SWFResource, res:String):void
		{
			clear();	
			
			var image:ImageAni = m_context.m_commonImageMgr.loadSWF(swf, ImageAni, res) as ImageAni;
			onLoaded(image);
		}
		
		public function isResourceName(res:String):Boolean
		{
			if (m_aniName)
			{
				if (m_aniName == "ani/" + res)
				{
					return true;
				}
			}
			return false;
		}
		
		//清除当前状态
		public function clear():void
		{
			m_gtWeen.paused = true;			
			m_bStop = true;
			m_loadState = Image.None;
			if (m_imageAni != null)
			{
				m_context.m_commonImageMgr.unLoad(m_imageAni.name);
				m_imageAni = null;
			}		
			
			if (m_aniName != null)
			{
				m_context.m_commonImageMgr.removeFun(m_aniName, onLoaded, onFailed);
				m_aniName = null;
			}
		}
		public function set repeatCount(count:int):void
		{
			m_gtWeen.repeatCount = count;
			
			if (count == 0)
			{
				setAutoStopWhenHide(true);
			}
		}
		
		public function setParam(_repeatCount:int, _centerPlay:Boolean, _mouseEnabled:Boolean, _duration:Number, _autoHideWhenComplete:Boolean, fcomp:Function=null):void
		{
			repeatCount = _repeatCount;
			m_bCenterPlay = _centerPlay;
			this.mouseEnabled = _mouseEnabled;
			m_gtWeen.duration = _duration;
			m_autoHideWhenComplete = _autoHideWhenComplete;			
			m_fcomp = fcomp;
		}
		
		public function set duration(dur:Number):void
		{
			m_gtWeen.duration = dur;
		}
		public function begin():void
		{
			if (m_bStop == false)
			{
				return;
			}
			m_bStop = false;
			if (m_imageAni != null)
			{
				beginEx();
			}
		}
		
		public function stop():void
		{
			if (m_bStop == true)
			{
				return;
			}
			m_bStop = true;
			m_gtWeen.paused = true;
		}
		
		public function set frame(fFrame:Number):void
		{
			if (m_imageAni == null)	return;
			m_fFrame = fFrame;
			var iFrame:uint = Math.round(m_fFrame);
			if (iFrame>=0&&iFrame < m_imageAni.frameCount)
			{
				// 帧改变回调
				if(m_fpreframe != null)
				{
					m_fpreframe(iFrame);
				}
				
				m_bitmap.bitmapData = m_imageAni.getFrame(iFrame);
				if (m_bCenterPlay)
				{
					m_bitmap.x = - (m_bitmap.bitmapData.width / 2);
					m_bitmap.y = - (m_bitmap.bitmapData.height / 2);
				}
				
				if (m_funOnFrameSpecified != null)
				{
					if (m_fFrame >= m_frameSpecified)
					{
						m_funOnFrameSpecified();
						m_funOnFrameSpecified = null;
					}
				}
			}
		}
		
		public function get frame():Number
		{
			return m_fFrame;
		}
		
		/*
		 * 自从看到此函数后，要显示调用它，以保证此对象被释放
		 */ 
		public function disposeEx():void
		{
			if (this.parent == null)
			{
				dispose();
			}
		}
		public function dispose():void
		{			
			if (m_bDisposed)
			{
				return;
			}
			if (m_imageAni != null)
			{
				m_context.m_commonImageMgr.unLoad(m_imageAni.name);
			}		
			
			if (m_aniName != null)
			{
				m_context.m_commonImageMgr.removeFun(m_aniName, onLoaded, onFailed);
			}
			
			m_gtWeen.paused = true;
			m_gtWeen.onChange = null;
			m_gtWeen.onComplete = null;
			m_gtWeen = null;
			m_fcomp = null;
			m_fpreframe = null;
			m_context = null;
			
			if (m_autoStopWhenHide)
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageToStage);
			}
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			m_bDisposed = true;
		}
		protected function onComplete(tween:GTween):void 
		{
			m_bStop = true;	
			if (m_autoHideWhenComplete)
			{
				hide();
			}
			if(m_fcomp != null)
			{
				m_fcomp(this);
			}
		}
		
		protected function onChange(tween:GTween):void 
		{
			if (m_funProgresscallBack != null)
			{
				if (tween.position >= m_timeProgresscallBack)
				{
					m_funProgresscallBack();
					m_funProgresscallBack = null;
					m_timeProgresscallBack = 0;
					tween.onChange = null;
				}
			}
		}
		import flash.utils.getQualifiedClassName;
		protected function onLoaded(resImage:Image):void
		{
			try
			{
			if (m_bDisposed)
			{
				var str:String="Ani::onLoaded, m_bDisposed==true, name="+resImage.name;
				DebugBox.info(str);
				DebugBox.sendToDataBase(str);
				return;
			}
			// 方便调试,最后清理
			//m_aniName = null;
			m_imageAni = resImage as ImageAni;
			if (m_imageAni.frameCount == 0)
			{
				str = "动画资源" + resImage.name + "错误";
				DebugBox.info(str);
				DebugBox.sendToDataBase(str);
				return;
			}
			m_loadState = Image.Loaded;
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED));
			
			if (m_bStop == true)
			{
				return;
			}
			
			beginEx();
			}
			catch (e:Error)
			{
				str = "Ani::onLoaded";
				if (resImage)
				{
					str += "resImage=" + getQualifiedClassName(resImage);	
					if (m_imageAni)
					{
						str += "m_imageAni";
					}
				}
				DebugBox.sendToDataBase(str);
				
			}
		}
		
		private function beginEx():void
		{
			if (m_autoStopWhenHide)
			{
				if (this.stage == null)
				{
					return;
				}
			}
			this.frame = -0.5;
			m_gtWeen.setValue("frame", m_imageAni.frameCount - 1+0.5);
			m_gtWeen.init();
			m_gtWeen.paused = false;			
		}
		protected function onFailed(filename:String):void
		{
			m_loadState = Image.Failed;
		}
		
		public function setProgressCallBack(time:Number, funCallBack:Function):void
		{
			m_funProgresscallBack = funCallBack;
			m_timeProgresscallBack = time;
			m_gtWeen.onChange = onChange;
		}
		
		public function set onCompleteFun(fun:Function):void
		{
			m_fcomp = fun;
		}
		
		public function set centerPlay(bFlag:Boolean):void
		{
			m_bCenterPlay = bFlag;
		}
		
		public function get imageLoaded():Boolean
		{
			return m_loadState == Image.Loaded;;
		}
		
		public function get isStop():Boolean
		{
			return m_bStop;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		
		public function get tag():int
		{
			return _tag;
		}
		public function set useFrames(b:Boolean):void
		{
			m_gtWeen.useFrames = b;
		}
		public function setAutoStopWhenHide(flag:Boolean=true):void
		{
			if (flag == m_autoStopWhenHide)
			{
				return;
			}
			m_autoStopWhenHide = flag;
			if (m_autoStopWhenHide)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageToStage);
			}
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageToStage);
			}
		}
		private function onAddedToStage(e:Event):void
		{
			if (this.isStop)
			{
				this.begin();
			}
			
		}
		private function onRemovedFromStageToStage(e:Event):void
		{
			this.stop();
		}
	
	}
}