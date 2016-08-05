package com.bit101.progressbar.progressbarClass1 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgressDefault;
	import com.bit101.components.progressBar.ProgressBar;
	import com.bit101.progressbar.progressAni.IProgressBarAni;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProgressBarClass1 extends Component implements IProgressBarAni 
	{
		private var m_progressBar:ProgressBar;
		private var m_bg:Panel;
		private var m_frame:Panel;
		private var m_effPanel:Panel;
		public function ProgressBarClass1(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
			m_bg = new Panel(this,0,4);
			m_bg.autoSizeByImage = false;
			m_bg.setSize(283,16);
			m_bg.setPanelImageSkin("commoncontrol/progress/bar1/bg.png");
			
			m_progressBar = new ProgressBar(this,0,4);
			var bar:BarInProgressDefault = new BarInProgressDefault();
			bar.autoSizeByImage = false;
			bar.setSize(283,18);
			bar.setPanelImageSkin("commoncontrol/progress/loadtrip.png");
			m_progressBar.maximum = 1;
			
			m_progressBar.setBar(bar);
			
			m_frame = new Panel(this);
			m_frame.setPanelImageSkin("commoncontrol/progress/bar1/frame.png");
			
			m_effPanel = new Panel(this,0,-15);
			m_effPanel.setPanelImageSkin("commoncontrol/progress/loadani.png");
			this.setSize(283,26);
		}
		
		/*
		 * v-[0,1]
		 */ 
		public function set value(v:Number):void
		{
			m_progressBar.value = v;
			m_effPanel.x = m_bg.width * v-57;
		}
		public function get value():Number
		{
			return m_progressBar.value;
		}
	}

}