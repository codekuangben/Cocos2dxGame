package com.bit101.progressbar.progressAni 
{
	import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProgressAni extends Component 
	{
		private var m_progressInstance:IProgressBarAni;
		private var m_ani:AniPropertys;
		private var m_funOnEnd:Function;
		public function ProgressAni(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_ani = new AniPropertys();			
			m_ani.onEnd = onEnd;
		}
		
		/*
		 * duration（秒）
		 */ 
		public function setParam(duration:Number, funOnEnd:Function, iPB:IProgressBarAni):void
		{
			m_funOnEnd = funOnEnd;
			m_ani.duration = duration;
			m_progressInstance = iPB;
			var ds:DisplayObject = m_progressInstance as DisplayObject;
			this.addChild(ds);
			this.setSize(ds.width,ds.height);
			m_ani.sprite = m_progressInstance;
		}
		public function begin():void
		{
			m_progressInstance.value = 0;
			m_ani.resetValues( { value:1 });
			m_ani.begin();
		}
		
		public function stop():void
		{
			m_ani.stop();
		}
		private function onEnd():void
		{
			if (m_funOnEnd != null)
			{
				m_funOnEnd();
			}
		}		
	}

}