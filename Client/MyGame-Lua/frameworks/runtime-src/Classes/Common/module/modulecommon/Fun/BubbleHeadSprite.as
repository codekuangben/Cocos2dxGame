package modulecommon.fun 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.TextAppearanceAni;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import modulecommon.GkContext;
	
	import common.event.UIEvent;
	import flash.events.Event;
	
	import common.Context;
	
	
	
	import flash.display.Sprite;
	
	//import flash.text.TextField;
	//import flash.text.TextFieldAutoSize;
	//import flash.text.TextFormat;
	import com.util.UtilColor;
	
	import modulecommon.appcontrol.BubbleWordDisplay;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BubbleHeadSprite extends Sprite 
	{
		private var m_width:uint;
		private var m_height:uint;
		private var m_gkContext:GkContext;
		private var m_context:Context;
		private var m_display:BubbleWordDisplay;
		private var m_tf:TextAppearanceAni;
		private var m_panel:Panel;
		private var m_mousePanel:Panel;
		private var m_nextLable:Label;
		
		private var m_timerForAutoTurnPage:Timer;
		private var m_strHtml:String;
		public function BubbleHeadSprite(gk:GkContext) 
		{
			m_gkContext = gk;
			m_context = m_gkContext.m_context;
			m_display = new BubbleWordDisplay(m_context);	
			m_display.onComposed = onComposed;
			addChild(m_display);
			
			m_panel = new Panel(this);
			//m_panel.setPos( -30, -30);
			m_panel.addEventListener(UIEvent.IMAGELOADED, onHalfHeadLoaded);
			
			//m_panel.setSize(120,130);
			m_panel.scaleX = 0.5;
			m_panel.scaleY = 0.5;
			
			m_tf = new TextAppearanceAni(this,100,12);
			m_tf.setSize(150, 200);	
			m_tf.speed = 300;
			m_tf.addEventListener(Event.COMPLETE, onTextAppearanceEnd);
			m_tf.setCSS("body", { leading:2, color:"#ffffff", fontSize:12,letterSpacing:1 } );
			
			m_width = m_tf.x + m_tf.width + 10;	
			
			m_mousePanel = m_display.mousePanel;
			m_mousePanel.setPos(165,68);
			m_mousePanel.autoSizeByImage = true;
			addChild(m_mousePanel);
			
			m_nextLable = new Label();
			m_nextLable.setPos(195,72);
			m_nextLable.setFontColor(UtilColor.tuple3Touint(95,222,25));
			m_nextLable.text = "点击继续";
			m_nextLable.visible = false;
			addChild(m_nextLable);
			
			m_timerForAutoTurnPage = new Timer(1500, 1);
			m_timerForAutoTurnPage.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		}
		
		private function onComposed():void
		{
			this.visible = true;
			m_tf.begin();
		}
		protected function onHalfHeadLoaded(e:UIEvent):void
		{
			m_panel.setPos(30 - m_panel.width * 0.25, 30 - m_panel.height * 0.25);
		}
		public function setText(content:String, strHead:String):void
		{
			m_timerForAutoTurnPage.stop();
			m_strHtml = content;
			this.visible = false;
			m_tf.htmlText = "<body>" + content + "</body>";
			
			m_mousePanel.visible = false;
			m_nextLable.visible = false;
				
			var resName:String = "halfing/" + strHead;			
			m_panel.setPanelImageSkin(resName);
			
			m_height = 100;
			m_display.setTextSize(m_width, m_height);			
		}
		private function onTextAppearanceEnd(e:Event):void
		{
			m_mousePanel.visible = true;
			m_nextLable.visible = true;
			m_timerForAutoTurnPage.reset();
			m_timerForAutoTurnPage.start();
			/*if(m_tf.tf.numLines < 4)
			{
				m_mousePanel.visible = true;
				m_nextLable.visible = true;
			}
			else
			{
				m_mousePanel.visible = false;
				m_nextLable.visible = false;
			}*/
			//if (m_gkContext.m_UIs.npcTalk)
			//{
			//	m_gkContext.m_UIs.npcTalk.setStopExec(true);
			//}
		}
		
		public function setPos(_x:int, _y:int):void
		{
			this.x = _x - m_width / 2 - 10;
			this.y = _y - m_height - 18;
		}
		
		public function dispose():void
		{
			m_display.dispose();
			m_panel.dispose();			
		}
		protected function onTimer(e:TimerEvent):void
		{
			if (this.m_gkContext.m_UIs.npcTalk)
			{
				this.m_gkContext.m_UIs.npcTalk.onDescActionTimeEnd(m_strHtml);			
			}
		}
	}

}