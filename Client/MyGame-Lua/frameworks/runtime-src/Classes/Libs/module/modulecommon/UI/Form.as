package modulecommon.ui
{
	//import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import com.bit101.components.Window;
	import com.dgrigg.image.Image;
	import com.dgrigg.skins.SkinForm;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import org.ffilmation.utils.mathUtils;
	
	import common.event.UIEvent;
	
	//import flash.display.Shape;
	import flash.display.Sprite;
	//import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import modulecommon.GkContext;
	import modulecommon.uiinterface.IForm;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Form extends Window implements IForm
	{
		
		
		
		protected var m_uiLayer:UILayer;
		
		protected var m_swfRes:SWFResource;
		protected var m_imageSWF:SWFResource;	//图片包
		protected var m_gkcontext:GkContext;
		
		protected var _bHideOnCreate:Boolean; //true - 创建完毕后，不可见
		protected var _bShowAfterAllImageLoaded:Boolean; //true - 所有图片加载完毕后显示
		protected var _darkBG:Sprite;		
		
		protected var m_aniForm:AniForm;
		protected var m_aniFormFade:AniFormFade;		
			
		protected var _bDarkeOthers:Boolean;
		public var m_ocMusic:Boolean = false; // 打开关闭界面是否播放,默认不播放
		
		protected var m_bCloseOnSwitchMap:Boolean = true;
		
		
		protected var m_hideTime:Number = 0; //隐藏界面的时刻 ProcessManager::_platformTime 或getTimer()
		protected var m_timeForTimingClose:Number = 0; //单位:毫秒，界面被隐藏后，经过m_timeForTimingClose时间后，销毁掉本界面
		
		public function Form()
		{
			super();
			_alignVertial = Component.CENTER;
			_alignHorizontal = Component.CENTER;
			_bShowAfterAllImageLoaded = true;		
		}
		
		public function set hideOnCreate(bHide:Boolean):void
		{
			_bHideOnCreate = bHide;
		}
		
		public function get hideOnCreate():Boolean
		{
			return _bHideOnCreate;
		}
		
		
		
		public function set gkcontext(cnt:GkContext):void
		{
			m_gkcontext = cnt;
		}
		
		public function get gkcontext():GkContext
		{
			return m_gkcontext;
		}
		
		public function set uiLayer(uiLayer:UILayer):void
		{
			var iShow:Boolean;
			if (m_uiLayer)
			{
				iShow = this.isVisible();
				m_uiLayer.removeForm(this);
			}
			m_uiLayer = uiLayer;
			m_uiLayer.addForm(this,iShow);
		}
		
		public function get uiLayer():UILayer
		{
			return m_uiLayer;
		}
		override public function isVisible():Boolean
		{
			return this.m_gkcontext.m_UIMgr.isFormVisible(this.id);
		}
		
		public function setSkinFormBySWF(swf:SWFResource, resName:String):void
		{
			var localSkin:SkinForm = new SkinForm();
			this.skin = localSkin;
			localSkin.setImageBySWF(swf, resName);
		}
		
		public function setSkinFormByImage(image:Image):void
		{
			var localSkin:SkinForm = new SkinForm();
			this.skin = localSkin;
			localSkin.setImage(image);
		}
		
		/*
		 * stage的大小发生变化后，这个函数会被调用。子类可重载这个函数
		 */
		public function onStageReSize():void
		{
			adjustPosWithAlign();
		}
		
		public function onShow():void
		{
			m_hideTime = 0;		
			
			if (m_aniForm)
			{
				m_aniForm.playAniForShow();
			}
			else
			{
				if (m_aniFormFade)
				{
					m_aniFormFade.fadeIn();
				}
				adjustPosWithAlign();
			}
		}
		
		public function onHide():void
		{
			m_hideTime = m_gkcontext.m_context.m_processManager.platformTime;
		}
		
		public function onDestroy():void
		{
			this.removeEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (m_aniFormFade)
			{
				m_aniFormFade.dispose();
				m_aniFormFade = null;
			}
			if (m_aniForm)
			{
				m_aniForm.dispose();
			}
			
			if (m_imageSWF)
			{
				m_gkcontext.m_context.m_resMgr.unload(m_imageSWF.filename, SWFResource);
				m_imageSWF = null;
			}
		}
		
		public function adjustPosWithAlign():void
		{
			var pos:Point = computeAdjustPosWithAlign();
			this.x = pos.x;
			this.y = pos.y;
			if (_bDarkeOthers == true)
			{
				this.darkOthers();
			}
		}
		
		protected function computeAdjustPosWithAlign():Point
		{
			var ret:Point = new Point();
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			if (alignVertial == CENTER)
			{
				ret.y = (heightStage - this.height) / 2;
			}
			else if (alignVertial == TOP)
			{
				ret.y = this._marginTop;
			}
			else
			{
				ret.y = heightStage - this.height - this._marginBottom;
			}
			
			if (alignHorizontal == CENTER)
			{
				ret.x = (widthStage - this.width) / 2;
			}
			else if (alignHorizontal == LEFT)
			{
				ret.x = _marginLeft;
			}
			else
			{
				ret.x = widthStage - this.width - _marginRight;
			}
			return ret;
		}
		
		
		
		public function set swfRes(swf:SWFResource):void
		{
			m_swfRes = swf;
		}
		
		public function get swfRes():SWFResource
		{
			return m_swfRes;
		}
		
		public function hasSwfRes():Boolean
		{
			return m_swfRes != null;
		}
		
		public function showOnAllImageLoaded():void
		{
			var str:String = getQualifiedClassName(this) + ":" + "showOnAllImageLoaded";
			m_gkcontext.addLog(str);
			this.hide();
			addEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
			this.beginCheckImageLoaded();
		}
		
		protected function onAllImageLoaded(e:UIEvent):void
		{
			var str:String = getQualifiedClassName(this) + ":" + "onAllImageLoaded";
			m_gkcontext.addLog(str);
			this.show();
		
		}
		
		public function darkOthers(color:uint = 0, alpha:Number = 0.5):void
		{
			if (_darkBG == null)
			{
				_darkBG = new Sprite();
			}
			if (!this.contains(_darkBG))
			{
				this.addChild(_darkBG);
				this.setChildIndex(_darkBG, 0);
			}
			
			// 绘制背景
			_darkBG.graphics.clear();
			
			_darkBG.graphics.beginFill(color, alpha);
			_darkBG.graphics.drawRect(-this.x, -this.y, m_gkcontext.m_context.m_config.m_curWidth, m_gkcontext.m_context.m_config.m_curHeight);
			_darkBG.graphics.endFill();
			_bDarkeOthers = true;
		}
		
		public function exit():void
		{
			if (m_aniForm&&m_aniForm.state == AniForm.STATE_AniHide)
			{
				return;
			}
			
			if (m_aniFormFade)
			{
				m_aniFormFade.fadeOut();
			}
			else if (m_aniForm)
			{
				m_aniForm.playAniForHide();
			}
			else
			{
				if (exitMode == EXITMODE_DESTORY)
				{
					this.m_gkcontext.m_UIMgr.destroyForm(this.id);
				}
				else
				{
					this.m_gkcontext.m_UIMgr.hideForm(this.id);
				}
			}
		}	
			
		public function show():void
		{			
			this.m_gkcontext.m_UIMgr.showForm(this.id);			
		}
		
		public function hide():void
		{
			this.m_gkcontext.m_UIMgr.hideForm(this.id);
		}
		
		public function destroy():void
		{
			//removeEventListener(UIEvent.AllIMAGELOADED, onAllImageLoaded);
			this.m_gkcontext.m_UIMgr.destroyForm(this.id);
		}
		
		protected function onExitBtnClick(e:MouseEvent):void
		{
			exit();
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.hide();
			}
		}
		
		protected function onImageSwfFailed(event:ResourceEvent):void
		{
		
		}
		
		public function updateData(param:Object = null):void
		{
		}
		
		public function getDestPosForHide():Point
		{
			return null;
		}
		
		public function getDestPosForShow():Point
		{
			return computeAdjustPosWithAlign();
		}		
		
		public function get showAfterAllImageLoaded():Boolean
		{
			return _bShowAfterAllImageLoaded;
		}
		
		//设置界面销毁的关闭的时间,单位是分钟
		public function set timeForTimingClose(time:Number):void
		{
			m_timeForTimingClose = time * 60 * 1000;
		}
		
		public function get timeForTimingClose():Number
		{
			return m_timeForTimingClose;
		}
		
		public function isTimeClose():Boolean
		{
			if (m_timeForTimingClose == 0)
			{
				return false;
			}
			if (m_gkcontext.m_context.m_processManager.platformTime - m_hideTime > m_timeForTimingClose)
			{
				return true;
			}
			return false;
		}
		
		public function get isInitiated():Boolean
		{
			return m_bInitiated;
		}
		
		public function get bCloseOnSwitchMap():Boolean
		{
			return m_bCloseOnSwitchMap;
		}	
		
		public function setAniForm(speed:Number=0):void
		{
			if (m_aniForm == null)
			{
				m_aniForm = new AniForm(this);
			}
			if (speed != 0)
			{
				m_aniForm.aniSpeed = speed;
			}
		}		
		
		public function setImageSWF(imageSWF:SWFResource):void
		{
			m_imageSWF = imageSWF;
		}
		public function resetShowParam():void
		{
			var destPos:Point = getDestPosForShow();
			alpha = 1;
			scaleX = 1;
			scaleY = 1;
			x = destPos.x;
			y = destPos.y;
		}
		
		public function setFade():void
		{
			if (m_aniFormFade == null)
			{
				m_aniFormFade = new AniFormFade(this);
			}
		}
		
		//return true-当前应该显示任务追踪
		public function isShouldShow():Boolean
		{
			return true;
		}
	}
}