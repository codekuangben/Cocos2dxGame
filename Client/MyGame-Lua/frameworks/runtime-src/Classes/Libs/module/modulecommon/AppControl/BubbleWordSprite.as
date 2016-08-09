package modulecommon.appcontrol 
{
	import com.riaidea.text.RichTextField;
	//import flash.display.BitmapData;
	import flash.display.Sprite;
	import common.Context;
	//import flash.display.Bitmap;
	//import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BubbleWordSprite extends Sprite 
	{
		private var m_width:uint;
		private var m_height:uint;
		private var m_context:Context;
		private var m_display:BubbleWordDisplay;		
		private var m_rtf:RichTextField;
		private var m_timer:Timer;
		protected var m_timerCompleteFun:Function;
		public function BubbleWordSprite(con:Context) 
		{
			m_context = con;
			m_display = new BubbleWordDisplay(m_context);			
			addChild(m_display);
			m_rtf = new RichTextField();
			m_rtf.setSize(200, 100);
			m_rtf.x = 10;
			m_rtf.y = 12;
			
			m_width = m_rtf.x * 2 + m_rtf.width;
			
			addChild(m_rtf);
			var format:TextFormat = new TextFormat();
			format.color = 0xffffff;
			format.size = 12;
			format.letterSpacing = 2;
			format.leading = 2;
			m_rtf.defaultTextFormat = format;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			m_timer = new Timer(200);			
		}
		
		public function setText(content:String):void
		{			
			m_rtf.clear();
			m_rtf.append(content);
			
			m_height = m_rtf.textfield.textHeight + 4 + 24;
			if (m_height < 41)
			{
				m_height = 41;
			}
			var w:uint = m_rtf.textfield.textWidth + 4;
			m_rtf.x = (m_width - w) / 2;
			m_display.setTextSize(m_width, m_height);
		}
		public function getTextLines():int
		{
			return m_rtf.textfield.numLines;
		}
		public function setPos(_x:int, _y:int):void
		{
			this.x = _x - m_width / 2 - 10;
			this.y = _y - m_height - 18;
		}
		
		protected function onTimer(e:TimerEvent):void
		{
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			m_timer.stop();
			if (m_timerCompleteFun != null)
			{
				m_timerCompleteFun();
			}
		}
		public function setTimerComplete(fun:Function):void
		{
			m_timerCompleteFun = fun;
		}
		
		public function setDelayTime(delay:Number):void
		{
			m_timer.reset();
			m_timer.delay = delay;
			m_timer.repeatCount = 1;
			m_timer.addEventListener(TimerEvent.TIMER, onTimer);
			m_timer.start();
		}
		public function dispose():void
		{
			if(m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				m_timer = null;
			}
			if(m_timerCompleteFun != null)
			{
				m_timerCompleteFun = null;
			}
			if (m_display != null)
			{
				m_display.dispose();
			}
			if(m_rtf)
			{
				m_rtf.dispose();
				m_rtf = null;
			}
		}
	}

}