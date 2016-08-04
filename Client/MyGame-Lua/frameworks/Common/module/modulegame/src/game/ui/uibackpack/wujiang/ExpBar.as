package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.BarInProgressDefault;
	import com.bit101.components.progressBar.ProgressBar;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ExpBar extends PanelContainer 
	{
		private static const NUMSEGMENT:uint = 4;
		private static const WIDTH:uint = 236;	//进度条的宽度
		private var m_gkContext:GkContext;
		private var m_progressBar:ProgressBar;
		private var m_vecSetment:Vector.<Panel>;
		public function ExpBar(gk:GkContext, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_progressBar = new ProgressBar(this, 0, 0);
			m_progressBar.setBar(new BarInProgressDefault());
			
			m_progressBar.setSize(WIDTH,13);
			//m_progressBar.setPanelImageSkin("backpage.expBarBG");
			m_progressBar.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);			
				
			bar.x = 2;
			bar.y = 3;
			bar.setSize(WIDTH - bar.x * 2, 7);
			//bar.setPanelImageSkin("backpage.expBar");
			
			
			m_vecSetment = new Vector.<Panel>(NUMSEGMENT);
			
			var unitWidth:int = (bar.width - NUMSEGMENT * 3) / 5;
			var left:int = bar.x + unitWidth;
			var interval:int = unitWidth + 3;
			
			for (var i:uint = 0; i < NUMSEGMENT; i++)
			{
				m_vecSetment[i] = new Panel(this, left, 1);
				m_vecSetment[i].setSize(3, 11);
				//m_vecSetment[i].setPanelImageSkin("backpage.expBarSegment");
				left += interval;
			}
			
		}
		
		protected function get bar():BarInProgressDefault
		{
			return (m_progressBar.bar as BarInProgressDefault);
		}
		public function set maximum(m:Number):void
		{
			m_progressBar.maximum = m;
		}
		public function set value(v:Number):void
		{
			m_progressBar.value = v;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_progressBar.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if (event.currentTarget is ProgressBar)
			{
				var panel:ProgressBar = event.currentTarget as ProgressBar;
				var pt:Point = panel.localToScreen(new Point(panel.width/2, 0));
				
				var str:String = panel.value.toString() + "/" + panel.maximum.toString();
				m_gkContext.m_uiTip.hintCondense(pt, str);
				m_progressBar.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		
		}
		
	}

}