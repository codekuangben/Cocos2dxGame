package modulecommon.appcontrol 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class AttrStrip extends PanelContainer 
	{
		private var m_topSegment:Panel;
		private var m_bottomSegment:Panel;
		public function AttrStrip(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			autoSizeByImage = false;
			setPanelImageSkin("commoncontrol/panel/tipwideblue.png");
			m_topSegment = new Panel(this);
			m_topSegment.autoSizeByImage = false;
			m_topSegment.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			m_bottomSegment = new Panel(this);
			m_bottomSegment.autoSizeByImage = false;
			m_bottomSegment.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			m_topSegment.setSize(w, 1);
			m_bottomSegment.y = h - 1;
			m_bottomSegment.setSize(w, 1);
		}
		
	}

}