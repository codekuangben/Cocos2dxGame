package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import common.Context;
	import common.event.UIEvent;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 * 带有符号的数字类
	 */
	public class DigitComponentWidthSign extends Component 
	{
		private var m_creator:DigitCreator;
		private var m_signPanel:Panel;
		public function DigitComponentWidthSign(con:Context, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_creator = new DigitCreator(con);
			m_creator.funAfterDraw = onDigitCreatorDraw;
			this.addChild(m_creator.panlDraw);
			
			m_signPanel = new Panel(this);
			this.addEventListener(UIEvent.IMAGELOADED, onChildImageLoaded);
		}
		public function setParam(path:String, interval:int, h:Number, pathSign:String, pathSignY:Number, digitOffset:Number):void
		{
			m_creator.setParam(path, interval, h);
			m_creator.panlDraw.x = digitOffset;
			
			m_signPanel.y = pathSignY;
			m_signPanel.setPanelImageSkin(pathSign);
		}

		private function onChildImageLoaded(e:UIEvent):void
		{
			if (e.target != this)
			{
				e.stopPropagation();
			}
		}
		
		public function set digit(n:uint):void
		{
			m_creator.digit = n;
			this.setSize(m_creator.width+m_creator.panlDraw.x, m_creator.height);
		}
		
		private function onDigitCreatorDraw():void
		{
			this.setSize(m_creator.width+m_creator.panlDraw.x, m_creator.height);
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
		override public function isAllImagesLoaded():Boolean 
		{
			return true;
		}
		override public function dispose():void 
		{
			m_creator.dispose();
			super.dispose();
		}
	}

}