package modulefight.digitani 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.bit101.components.Panel;	
	import common.Context;
	import common.event.UIEvent;
	import flash.display.DisplayObjectContainer;	
	//import modulecommon.appcontrol.DigitComponent;
	import modulecommon.appcontrol.DigitComponentWidthSign;

	public class DigitBaojiDisplay extends Panel 
	{
		private var m_bg:Panel;
		private var m_digit:DigitComponentWidthSign;
		private var m_baoji:Panel;
		
		public function DigitBaojiDisplay(con:Context, parent:DisplayObjectContainer = null) 
		{
			super(parent);
			this.addEventListener(UIEvent.IMAGELOADED, onChildImageLoaded);
			m_bg = new Panel(this);
			m_bg.setPanelImageSkin("commoncontrol/digit/baojidigit/11.png");
			m_digit = new DigitComponentWidthSign(con, this);
			m_digit.setParam("commoncontrol/digit/baojidigit", 32,55,"commoncontrol/digit/baojidigit/subtract.png",20,36);		
			m_digit.y = 20;
			m_digit.addEventListener(UIEvent.IMAGELOADED, onDigitCreatorDraw);
			
			
			m_baoji = new Panel(this);
			m_baoji.setPanelImageSkin("commoncontrol/digit/baojidigit/10.png");
			m_baoji.y = 34;
		}
		public function setDigit(n:int, type:int):void
		{
			m_digit.digit = n;
			
		}
		private function onChildImageLoaded(e:UIEvent):void
		{
			if (e.target != this)
			{
				e.stopPropagation();
			}
		}
		private function onDigitCreatorDraw(e:UIEvent):void
		{
			if (e.target != m_digit)
			{
				return;
			}
			var w:uint = 0;
			w = m_digit.width + 40 + 70;	
			
			m_bg.scaleX = w / 287;
			m_digit.x = 23;
			m_baoji.x = m_digit.width + m_digit.x - 16;
						
			this.width = w;
			this.height = 112;
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
	}

}