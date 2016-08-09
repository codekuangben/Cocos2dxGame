package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	//import com.bit101.components.Panel;
	//import com.bit101.components.PanelDraw;
	//import com.dgrigg.image.PanelImage;
	//import com.dgrigg.utils.ImageTempStorage;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	//import flash.utils.Dictionary;
	import common.event.UIEvent;
	/**
	 * ...
	 * @author 
	 * 这是一个数字控件。每个数字是一个图片
	 */
	public class DigitComponent extends Component 
	{
		private var m_creator:DigitCreator;
		private var m_align:int = Component.LEFT;
		
		public function DigitComponent(con:Context, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_creator = new DigitCreator(con);
			m_creator.funAfterDraw = onDigitCreatorDraw;
			this.addChild(m_creator.panlDraw);
		}
			
		public function setParam(path:String, interval:int, h:Number):void
		{
			m_creator.setParam(path, interval, h);		
		}
		public function set digit(n:uint):void
		{
			m_creator.digit = n;
			this.setSize(m_creator.width, m_creator.height);
			var xPos:Number=0;
			if (m_align == Component.LEFT)
			{
				xPos = 0;
			}
			else if (m_align == Component.CENTER)
			{
				xPos = -this.width / 2;
			}
			else if( m_align == Component.RIGHT)
			{
				xPos = -this.width;
			}
			m_creator.panlDraw.x = xPos;
		}
		
		private function onDigitCreatorDraw():void
		{
			this.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true));
		}
		
		override public function dispose():void 
		{
			m_creator.funAfterDraw = null;
			m_creator.dispose();
			super.dispose();
		}
		public function set align(align:int):void
		{
			m_align = align;
		}
	}

}