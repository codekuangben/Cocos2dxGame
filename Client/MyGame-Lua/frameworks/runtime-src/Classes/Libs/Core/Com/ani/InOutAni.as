package com.ani 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.GTween;
	//import flash.display.Sprite;
	
	public class InOutAni extends DigitAniBase 
	{
		private var m_gtWeen:GTween;
		private var m_delay:Number = 1;		
		private var m_onSecondStepFun:Function;
		public function InOutAni() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.paused = true;			
			m_gtWeen.useFrames = false;
			//m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;
		}
		
		override public function begin():void
		{
			
			m_sp.alpha = 0;
			m_gtWeen.target = m_sp;
			if (m_gtWeen.data == 1)
			{
				m_gtWeen.setValues( { y:m_sp.y + 10, alpha:1 } );
			}
			else
			{
				m_gtWeen.setValues( { y:m_sp.y - 10, alpha:1 } );
			}
			m_gtWeen.ease = Quadratic.easeIn;
			m_gtWeen.onComplete = onStep;
			m_gtWeen.onChange = null;
			m_gtWeen.duration = 0.2;
			//m_gtWeen.data = 0;
			m_gtWeen.init();
			m_gtWeen.paused = false;
			super.begin();
			
		}
		override public function dispose():void 
		{
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen.onChange = null;
			m_gtWeen.onComplete = null;
			m_onSecondStepFun = null;
			super.dispose();			
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
		protected function onStep(tween:GTween):void
		{
			var step:uint = m_gtWeen.data as uint;
			switch(step)
			{
				case 0:
					{
						m_gtWeen.resetValues( { y:m_sp.y - 30, alpha:0 } );
						break;
					}				
				case 1:
					{
						m_gtWeen.resetValues( { y:m_sp.y + 30, alpha:0 } );
						break;
					}
			}
			m_gtWeen.ease = Linear.easeNone;
			m_gtWeen.duration = 0.5;
			m_gtWeen.delay = m_delay;
			//m_gtWeen.data = 1;
			m_gtWeen.init();
			m_gtWeen.onChange = onChange;
			m_gtWeen.onComplete = onComplete;
		}
		
		private function onChange(tween:GTween):void
		{
			if (m_gtWeen.position >= 0)
			{
				if (m_onSecondStepFun != null)
				{
					m_onSecondStepFun();
				}			
				m_gtWeen.onChange = null;
			}			
		}
		
		public function set delay(delay:Number):void
		{
			m_delay = delay
		}
		
		//0 ����; 1 ����
		public function set direct(direct:int):void
		{
			m_gtWeen.data = direct;
		}
		
		public function set onSecondStepFun(fun:Function):void
		{
			m_onSecondStepFun = fun;
		}
	}

}