package com.ani 
{
	/**
	 * ...
	 * @author 
	 * 让数字指定范围内顺序变化
	 */
	import com.gskinner.motion.GTween;
	public class AniIntChange extends DigitAniBase 
	{
		protected var m_minNumber:int;
		protected var m_maxNumber:int;
		protected var m_duration:Number;
		private var m_curFrame:Number;
		private var m_curIntFrame:Number;
		
		private var m_gtWeen:GTween;
		/*
		 * m_funOnAniIntChange的函数形式是
		 * 	public function onAniIntChange(frame:int):void{}
		 * 当帧数改变时，就会回调这个函数
		 */ 
		private var m_funOnAniIntChange:Function;
		public function AniIntChange() 
		{
			m_gtWeen = new GTween();
			m_gtWeen.paused = true;
			m_gtWeen.autoPlay = false;			
			m_gtWeen.useFrames = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;	
		}
		
		public function setParam(minNumber:int, maxNumber:int, duration:Number, funOnAniIntChange:Function):void
		{
			m_minNumber = minNumber;
			m_maxNumber = maxNumber;
			m_duration = duration;
			m_funOnAniIntChange = funOnAniIntChange;
		}
		override public function begin():void 
		{
			super.begin();			
			m_curIntFrame = m_minNumber - 1;
			m_curFrame = m_minNumber - 0.49999;
			
			m_gtWeen.target = this;
			m_gtWeen.setValue("frame", m_maxNumber + 0.49999);
			m_gtWeen.duration = m_duration;
			m_gtWeen.paused=false;
		}
		
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
		
		override public function dispose():void 
		{
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen = null;
			m_funOnAniIntChange = null;
			super.dispose();
		}
		public function set frame(v:Number):void
		{
			m_curFrame = v;			
			var a:int = Math.round(m_curFrame);
			if (a != m_curIntFrame)
			{
				m_curIntFrame = a;
				if (m_funOnAniIntChange!=null)
				{
					m_funOnAniIntChange(m_curIntFrame);
				}
			}
		}
		public function get frame():Number
		{
			return m_curFrame;
		}
		public function set repeatCount(t:int):void
		{
			m_gtWeen.repeatCount = t;
		} 
		public function setEaseByConst(type:int):void
		{
			m_gtWeen.ease = AniDef.s_getEaseFun(type);
		}
	}

}