package modulefight.ui.uiFightResult 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import common.event.UIEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import com.ani.AniPropertys;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 * 胜利动画
	 */
	public class WinAni extends Component 
	{
		public static const STATE_Init:int = 0;
		public static const STATE_WaitLoad:int = 1;
		public static const STATE_PlayAni:int = 2;
		
		private var m_gkContext:GkContext;
		
		public var m_state:int;
		
		private var m_ani:Ani;
		private var m_bottomPanel:Panel;
		private var m_bg:Panel;
		private var m_exp:Panel;
		private var m_addPanel:Panel;
		private var m_expDigit:DigitComponent;
		//private var m_money:Label;
		private var m_bottomAni:AniPropertys;
		private var m_ui:UIFightResult;
	
		private var m_bShowbottomPanel:Boolean;
		public function WinAni(gk:GkContext, ui:UIFightResult) 
		{
			m_gkContext = gk;
			m_ui = ui;
			
			
			m_bottomPanel = new Panel(this, -260, 100);
			m_bottomPanel.visible = false;
			m_bg = new Panel(m_bottomPanel);
			m_bg.addEventListener(UIEvent.IMAGELOADED, onAniLoad);
			m_bg.setPanelImageSkin("commoncontrol/panel/battlebg.png");
			
			m_exp = new Panel(m_bottomPanel, 105, 75);
			m_exp.setPanelImageSkin("commoncontrol/panel/word_exp2.png");
			
			m_addPanel = new Panel(m_bottomPanel, 170, 82);
			m_addPanel.setPanelImageSkin("commoncontrol/digit/digit02/add.png");
			
			m_expDigit = new DigitComponent(m_gkContext.m_context, m_bottomPanel, 193, 83);
			m_expDigit.setParam("commoncontrol/digit/digit02",16,25);
		
			//m_money = new Label(m_bottomPanel, 230, 85);
			m_bottomAni = new AniPropertys();
			
			
			m_ani = new Ani(m_gkContext.m_context);
			this.addChild(m_ani);
			m_ani.setImageAni("ejshengli.swf");
			m_ani.duration = 1;
			m_ani.repeatCount = 1;
			m_ani.centerPlay = true;
			m_ani.onCompleteFun = onEnd;
			m_ani.addEventListener(UIEvent.IMAGELOADED, onAniLoad);
			
			m_state = STATE_Init;
		}
		
		private function onAniLoad(e:Event):void
		{
			if (m_ani.imageLoaded && m_bg.imageLoaded)
			{
				begin();
			}
		}
		
		public function setData(exp:int, money:int):void
		{			
			if (m_state != STATE_Init)
			{
				return;
			}
			m_expDigit.digit = exp;
			
			if (exp == 0)
			{
				m_bShowbottomPanel = false;
			}
			else
			{
				m_bShowbottomPanel = true;
			}
			
			if (m_ani.imageLoaded && m_bg.imageLoaded)
			{
				begin();
			}
			else
			{
				m_state = STATE_WaitLoad;
			}
		}
		override public function dispose():void 
		{
			super.dispose();
			m_ani.disposeEx();
			m_bottomAni.dispose();
		}
		private function begin():void
		{
			m_state = STATE_PlayAni;
			m_ani.begin();
			var rect:Rectangle = new Rectangle(0, 0, 0, 191);
			m_bottomPanel.scrollRect = rect;
			m_bottomPanel.visible = m_bShowbottomPanel;
			
			m_bottomAni.sprite = this;
			m_bottomAni.duration = 0.5;
			m_bottomAni.resetValues( { bgWidth:541 } );
			m_bottomAni.begin();			
		}
		
		public function set bgWidth(w:Number):void
		{
			var rect:Rectangle = m_bottomPanel.scrollRect;
			rect.width = w;
			m_bottomPanel.scrollRect = rect;		
		}
		
		public function get bgWidth():Number
		{
			var rect:Rectangle = m_bottomPanel.scrollRect;
			if (rect)
			{
				return rect.width;
			}
			return 0;
		}
		
		protected function onEnd(ani:Ani):void
		{
			m_ui.onAniEnd();
			
			m_state = STATE_Init;			
		}
	}
}