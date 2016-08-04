package game.ui.uiPlotTips 
{
	import com.ani.AniPropertys;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.easing.Quartic;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	/**
	 * ...
	 * @author ...
	 * 剧情提示
	 */
	public class UIPlotTips extends Form
	{
		private var m_container:PanelContainer;
		private var m_iconPanel:Panel;
		private var m_titlePanel:Panel;
		private var m_descLabel:Label;
		private var m_btn:ButtonText;
		private var m_closeBtn:PushButton;
		private var m_timer:Timer;
		private var m_funcid:uint;
		private var m_ani:AniPropertys;
		
		public function UIPlotTips() 
		{
			super();
			this.exitMode = EXITMODE_HIDE;
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			this.alignVertial = Component.BOTTOM;
			this.marginBottom = 110;
			this.setSize(480, 138);
			
			m_container = new PanelContainer(this, 0, 238);
			m_container.setSize(480, 138);
			m_container.setPanelImageSkin("commoncontrol/panel/plottipsBg.png");
			m_container.alpha = 0;
			
			m_iconPanel = new Panel(m_container, 28, 40);
			m_titlePanel = new Panel(m_container, 110, 22);
			m_descLabel = new Label(m_container, 130, 82, "", UtilColor.WHITE_Yellow);
			m_descLabel.mouseEnabled = true;
			
			m_btn = new ButtonText(m_container, 320, 80, "点击", onBtnClick);
			m_btn.setSize(60, 20);
			m_btn.overColor = UtilColor.GREEN;
			m_btn.normalColor = UtilColor.GREEN;
			m_btn.labelComponent.underline = true;
			
			m_closeBtn = new PushButton(m_container, 410, 76, onCloseBtnClick);
			m_closeBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			m_timer = new Timer(60000);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer.repeatCount = 1;
			
			m_ani = new AniPropertys();
			m_ani.onEnd = null;
			m_ani.sprite = m_container;
		}
		
		override public function updateData(param:Object = null):void
		{
			super.updateData(param);
			
			var str:String = "";
			
			str = param["icon"] as String;
			if (str && "" != str)
			{
				m_iconPanel.setPanelImageSkin("vip/" + str + ".png");
			}
			
			str = param["title"] as String;
			if (str && "" != str)
			{
				m_titlePanel.setPanelImageSkin("plottips/" + str + ".png");
			}
			
			str = param["desc"] as String;
			if (str && "" != str)
			{
				m_descLabel.text = str;
			}
			
			str = param["btnstr"] as String;
			if (str && "" != str)
			{
				m_btn.label = str;
			}
			
			if (undefined != param["funcid"])
			{
				m_funcid = param["funcid"];
			}
			
			this.show();
		}
		
		override public function onShow():void
		{
			super.onShow();
			
			m_timer.reset();
			m_timer.start();
			
			onUIShowAniBegin();
		}
		
		override public function exit():void
		{
			m_timer.reset();
			
			super.exit();
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
			
			super.dispose();
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			onUIExitAniBegin();
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			if (m_funcid > 0)
			{
				m_gkcontext.m_sysnewfeatures.openOneFuncForm(m_funcid);
			}
			
			onUIExitAniBegin();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			onUIExitAniBegin();
		}
		
		//界面显示动画开始
		private function onUIShowAniBegin():void
		{
			m_container.y = 238;
			m_container.alpha = 0;
			m_ani.onEnd = null;
			
			m_ani.resetValues( { alpha:1, y: 0 } );
			m_ani.ease = Quartic.easeIn;
			m_ani.duration = 0.6;
			m_ani.begin();
		}
		
		//界面显示动画结束
		private function onUIExitAniBegin():void
		{
			m_ani.onEnd = onUIHideAniEnd;
			m_ani.resetValues( { alpha: 0, y: -30 } );
			m_ani.ease = Quartic.easeOut;
			m_ani.duration = 1;
			m_ani.begin();
		}
		
		//界面关闭动画结束
		private function onUIHideAniEnd():void
		{
			m_container.y = 238;
			this.exit();
		}
	}

}