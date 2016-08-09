package com.bit101.components.app 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class WallPanel extends Component 
	{
		private var m_bFrame:Boolean;
		private var m_framePanel:Panel;
		private var m_wallPanel:Panel;
		public function WallPanel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_wallPanel = new Panel();
		}
		public function setParam(bFrame:Boolean):void
		{
			m_bFrame = bFrame;
			if (m_bFrame)
			{
				if (m_framePanel == null)
				{
					m_framePanel = new Panel();	
					m_framePanel.setSkinGrid9Image9("commoncontrol/grid9/grid9StyleOne.swf");
				}
				m_framePanel.setSize(this.width, this.height);
			}
			m_wallPanel
		}
	}

}