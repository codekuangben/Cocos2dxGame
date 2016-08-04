package game.ui.uiNewHand.focus 
{
	import com.bit101.components.Component;
	import com.ani.AniPropertys;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class Circle extends Component 
	{
		public static const MAXALPHA:Number = 1;
		public static const MAXALPHA2:Number = 2 * MAXALPHA;
		private var m_ani:AniPropertys;
		private var m_alphaVar:Number;	//[0-2]
		private var m_bRun:Boolean;
		private var m_alpha:Number = 0.6;
		
		public function Circle(parent:DisplayObjectContainer = null) 
		{
			super(parent);
			alphaVar = 0;
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.duration = 1;
			m_ani.onEnd = onEnd;
			m_ani.resetValues({alphaVar:MAXALPHA2});
			
			this.setSkinGrid9Image9("commoncontrol/grid9/tasktraceOver.swf");
		}
		
		public function get alphaVar():Number
		{
			return m_alphaVar;
		}
		public function set alphaVar(v:Number):void
		{
			m_alphaVar = v;
			if (m_alphaVar <= MAXALPHA)
			{
				midAlpha = m_alphaVar;
			}
			else
			{				
				midAlpha = Math.pow(MAXALPHA2 - m_alphaVar, m_alpha);
				//alpha = MAXALPHA2 - m_alphaVar;
			}		
		}
		private function set midAlpha(v:Number):void
		{
			alpha = v * m_alpha;
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();			
		}
		private function onEnd():void
		{
			m_bRun = false;
		}
		
		public function begin():void
		{
			m_alphaVar = 0;
			m_ani.begin();
			m_bRun = true;
		}
		public function end():void
		{
			m_ani.end();
			m_bRun = false;
		}
		public function get isRun():Boolean
		{
			return m_bRun;
		}
		
		public function setRectangle(rect:Rectangle):void
		{
			this.setPos(rect.x, rect.y);
			this.setSize(rect.width, rect.height);
			this.draw();
		}
		
		public function setFlickerValue():void
		{
			m_ani.repeatCount = 0;
			m_ani.duration = 0.2;
			m_alpha = 1;
			this.setSkinGrid9Image9("commoncontrol/grid9/selectgrid9.swf");
		}
	}

}