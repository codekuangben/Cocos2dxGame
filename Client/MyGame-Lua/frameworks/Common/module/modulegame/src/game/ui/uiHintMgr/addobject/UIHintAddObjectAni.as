package game.ui.uiHintMgr.addobject 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.PanelShowAndHide;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	import flash.display.DisplayObjectContainer;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import game.ui.uiHintMgr.UIHintMgr;
	/**
	 * ...
	 * @author 
	 */
	public class UIHintAddObjectAni extends Form 
	{		
		private var m_bg:Ani;
		private var m_forgroundAni:Ani;
		private var m_topPart:TopPart;
		protected var m_timer:Timer;
		protected var m_uiHintMgr:UIHintMgr;
		public function UIHintAddObjectAni() 
		{
			this.id = UIFormID.UIHintAddObjectAni;
		}
		override public function onReady():void 
		{
			super.onReady();
			this.exitMode = EXITMODE_HIDE;
			setFade();
			this.alignVertial = Component.BOTTOM;
			this.marginBottom = 200;
			m_bg = new Ani(m_gkcontext.m_context);
			this.addChild(m_bg);
			m_bg.centerPlay = true;
			m_bg.setImageAni("ejhuodezhuangbei.swf");
			m_bg.duration = 1;
			
			m_topPart = new TopPart(m_gkcontext, this);
			
			m_forgroundAni = new Ani(m_gkcontext.m_context);
			
			m_forgroundAni.centerPlay = true;
			m_forgroundAni.setImageAni("ejanniushandian.swf");
			m_forgroundAni.duration = 1;
			m_forgroundAni.repeatCount = 0;
			m_forgroundAni.mouseEnabled = false;
			
			m_timer = new Timer(30000);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer.repeatCount = 1;
			
			m_uiHintMgr = m_gkcontext.m_UIMgr.getForm(UIFormID.UIHintMgr) as UIHintMgr;		
		}
		
		public function begin():void
		{
			this.alpha = 1;
			m_topPart.hide();
			if (m_forgroundAni.parent)
			{
				m_forgroundAni.parent.removeChild(m_forgroundAni);
			}
			m_bg.m_frameSpecified = 10;
			m_bg.m_funOnFrameSpecified = beginOtherAni;
			m_bg.begin();
			
			m_timer.reset();
			m_timer.start();
		}	
		
		override public function exit():void 
		{
			m_timer.reset();
			super.exit();
		}
		
		private function beginOtherAni():void
		{
			m_topPart.beginAni();
			if (m_forgroundAni.parent==null)
			{
				this.addChild(m_forgroundAni);
			}
			m_forgroundAni.begin();
		}
		
		public function addObject(obj:ZObject):void
		{
			m_topPart.addObject(obj);
		}
		override public function dispose():void 
		{
			if (m_forgroundAni.parent == null)
			{
				m_forgroundAni.dispose();
			}
			
			if (m_topPart.parent == null)
			{
				m_topPart.dispose();
			}
			super.dispose();
			m_uiHintMgr.onUIHintAddObjectAniDispose();
		}
		
		
		protected function onTimer(e:TimerEvent):void
		{			
			exit();
		}
	}

}