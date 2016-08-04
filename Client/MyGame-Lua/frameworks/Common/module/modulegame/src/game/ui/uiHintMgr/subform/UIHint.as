package game.ui.uiHintMgr.subform 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import common.event.UIEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import com.ani.AniPosition;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.ui.Form;
	import game.ui.uiHintMgr.UIHintMgr;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIHint extends Form 
	{
		protected var m_uiMgr:UIHintMgr;		
		
		protected var m_exitBtn:PushButton;
		protected var m_funBtn:ButtonText;
		protected var m_tf:TextNoScroll;
		protected var m_aniPos:AniPosition;
		protected var m_timer:Timer;
		
		public function UIHint(mgr:UIHintMgr) 
		{
			m_uiMgr = mgr;
			
			m_timer = new Timer(30000);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer.repeatCount = 1;
			m_timer.start();
			
			this.draggable = false;
			this.setSize(256,181);			
			this.setPanelImageSkin("commoncontrol/panel/hintback.png");
			
			m_exitBtn = new PushButton(this, 223,3,onExitBtnClick);
			m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn2.swf");
			
			m_funBtn = new ButtonText(this, 67, 125,"",onFunBtnClick);
			m_funBtn.setSize(130, 40);
			m_funBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			m_funBtn.letterSpacing = 4;
			m_funBtn.normalColor = 0xfbdda2;
			m_funBtn.overColor = 0xfff1d6;
			m_funBtn.downColor = 0xf3c976;
			m_funBtn.labelComponent.setFontSize(14);
			m_funBtn.labelComponent.setBold(true);
			
			m_tf = new TextNoScroll();
			this.addChild(m_tf);
			m_tf.width = 150;
			m_tf.x = 88;
			m_tf.setCSS("body", {leading:3, letterSpacing:1, color:"#fbdda2" } );//e0e0e0
			
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.BOTTOM;
			this.marginRight = 40;
			this.marginBottom = 100;
			setFade();
			
		}
		
		override protected function onAllImageLoaded(e:UIEvent):void 
		{
			super.onAllImageLoaded(e);
			
			m_aniPos = new AniPosition();
			m_aniPos.sprite = this;
			m_aniPos.onEnd = onAniMoveEnd;
			m_aniPos.duration = 0.8;
			m_aniPos.setEndPos(this.x, this.y);
			m_aniPos.setBeginPos(this.x + this.width + this._marginRight, this.y);
			m_aniPos.begin();
		}
		override public function onReady():void 
		{
			super.onReady();		
		}		
		
		override public function onDestroy():void 
		{
			super.onDestroy();
			m_uiMgr.onUIHintDestroy(this);
			if(m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_timer = null;
			}
		}
		
		protected function setText(str:String):void
		{
			m_tf.htmlText = "<body>" + str + "</body>";
			var centerY:Number = 69;
			m_tf.y = centerY - m_tf.height/2;
		}
		protected function onFunBtnClick(e:MouseEvent):void
		{
			
		}
		
		protected function onAniMoveEnd():void
		{
			
		}
		
		protected function onTimer(e:TimerEvent):void
		{
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			exit();
		}
		
		override public function dispose():void
		{
			if (m_aniPos)
			{
				m_aniPos.dispose();
				m_aniPos = null;
			}
			
			super.dispose();
		}
	}

}