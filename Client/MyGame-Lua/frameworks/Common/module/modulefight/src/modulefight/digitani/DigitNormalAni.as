package modulefight.digitani 
{
	import com.ani.AniPropertys;
	import com.ani.DigitAniBase;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	//import com.gskinner.motion.easing.Sine;
	//import flash.display.Sprite;

	/**
	 * ...
	 * @author zouzhiqiang
	 * 此动画是高度提升的同时，alpha变小
	 */
	public class DigitNormalAni extends DigitAniBase
	{
		private var m_ani:AniPropertys;
		private var m_yDistance:uint = 170;		
		public function DigitNormalAni() 
		{
			m_ani = new AniPropertys();					
			
			//m_gtWeen.ease = Exponential.easeIn;//Sine.easeIn;//Exponential.easeIn
					
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();
		}
		override public function begin():void
		{			
			m_sp.alpha = 0;
			m_ani.sprite = m_sp;
			m_ani.resetValues({alpha:1, y:m_sp.y-60});			
			m_ani.duration = 0.5;
			m_ani.ease = Exponential.easeOut;
			m_ani.onEnd = onStep1End;
			m_ani.begin();		
			super.begin();
		}
		override public function stop():void
		{
			super.stop();			
			m_ani.stop();
		}
		private function onStep1End():void
		{
			m_ani.resetValues({alpha:0, y:m_sp.y-200});			
			m_ani.duration = 0.7;		
			m_ani.ease = Linear.easeNone;
			m_ani.onEnd = onStep2End;
			m_ani.begin();
		}
		private function onStep2End():void
		{
			if (m_onEnd != null)
			{
				m_onEnd();				
			}
		}
		public function set yDistance(d:uint):void
		{
			m_yDistance = d;
		}
			
	}

}