package modulefight.digitani
{
	import com.bit101.components.Panel;
	//import com.dgrigg.display.DisplayCombinationBase;
	//import com.util.PBUtil;
	import common.Context;
	import common.event.UIEvent;
	//import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	//import flash.geom.Matrix;
	//import flash.geom.Point;
	//import flash.geom.Rectangle;
	//import modulecommon.appcontrol.DigitComponent;
	import modulecommon.appcontrol.DigitComponentWidthSign;
	
	/**
	 * @brief 反击调血显示
	 * */
	public class DigitFanJiDisplay extends Panel
	{
		private var m_bg:Panel;
		public var m_digit:DigitComponentWidthSign;
		private var m_baoji:Panel;
		
		public function DigitFanJiDisplay(con:Context, parent:DisplayObjectContainer = null) 
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
			m_baoji.setPanelImageSkin("commoncontrol/digit/baojidigit/word_fanji.png");
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
			w = m_digit.width + 40 + 55;	
			
			m_bg.scaleX = w / 287;
			m_digit.x = 23;
			m_baoji.x = m_digit.width + m_digit.x - 25;
						
			this.width = w;
			this.height = 112;
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
	}
}