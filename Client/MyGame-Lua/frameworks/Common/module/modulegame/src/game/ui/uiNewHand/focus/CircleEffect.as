package game.ui.uiNewHand.focus 
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.Component;
	import flash.geom.Rectangle;
	//import flash.utils.Timer;
	import com.ani.AniPropertys;
	/**
	 * ...
	 * @author 
	 */
	public class CircleEffect extends Component 
	{
		public static const CIRCLE_NUM:int = 4;
		private var m_ani:AniPropertys;
		private var m_circleTime:Number;
		private var m_list:Vector.<Circle>;	//索引0表示最外面的框
		public function CircleEffect()
		{		
			
			m_list = new Vector.<Circle>(CIRCLE_NUM);
			var i:int;
			for (i = 0; i < CIRCLE_NUM; i++)
			{
				m_list[i] = new Circle(this);
			}	
			
			m_circleTime = 0;
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.duration = 1.8;
			m_ani.repeatCount = 0;
			
		}
		
		public function setRectangle(rect:Rectangle):void
		{
			this.setPos(rect.x, rect.y);
			
			var i:int;
			var cirRect:Rectangle = new Rectangle(0 - 8, -8, rect.width+16, rect.height+16);
			for (i = CIRCLE_NUM - 1; i >=0; i--)
			{
				m_list[i].setRectangle(cirRect);
				cirRect.x -= (4 + (CIRCLE_NUM - i) * 5);
				cirRect.y -= (4 + (CIRCLE_NUM - i) * 5);
				cirRect.width += (8 + (CIRCLE_NUM - i) * 10);
				cirRect.height += (8 + (CIRCLE_NUM - i) * 10);
			}
		}
		
		public function begin():void
		{
			circleTime = 0;
			m_ani.resetValues( { circleTime:10 } );
			m_ani.begin();
		}
		public function end():void
		{
			m_ani.end();
			var i:int;
			for (i = 0; i < CIRCLE_NUM; i++)
			{
				m_list[i].end();
			}
		}
		
		public function set circleTime(v:Number):void
		{
			m_circleTime = v;
			var index:int = v;
			if (index < CIRCLE_NUM)
			{
				if (m_list[index].isRun == false)
				{
					m_list[index].begin();
				}
			}
		}
		public function get circleTime():Number
		{
			return m_circleTime;
		}
		
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();
		}
	}

}