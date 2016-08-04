package modulefight.digitani 
{
	import com.ani.AniPropertys;
	import com.ani.DigitAniBase;
	import com.ani.AniPause;
	import com.gskinner.motion.easing.Exponential;
	//import com.gskinner.motion.easing.Linear;
	//import com.gskinner.motion.easing.Sine;
	
	//import flash.display.Sprite;
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author 
	 * 此动画是高度提升的同时，alpha变小
	 */
	public class BBNameNormalAni extends DigitAniBase
	{
		private var m_ani:AniPropertys;
		private var m_yDistance:uint = 170;
		private var m_type:uint;
		private var m_aniPause:AniPause;
		
		public function BBNameNormalAni(type:uint)
		{
			m_type = type;		// 增益减益
			m_ani = new AniPropertys();
			m_aniPause = new AniPause();
		}
		
		override public function dispose():void 
		{
			m_ani.dispose();
			m_aniPause.dispose();
			super.dispose();
		}
		override public function stop():void
		{
			super.stop();
			m_ani.stop();
			m_aniPause.stop();
		}
		override public function begin():void
		{			
			m_sp.alpha = 0;
			m_sp.scaleX = 0;
			m_sp.scaleY = 0;
			
			m_ani.sprite = m_sp;
			/*if(FightEn.NTUp == m_type)
			{
				m_ani.resetValues({alpha:1, y:m_sp.y-60});
			}
			else if(FightEn.NTDn == m_type)
			{
				m_ani.resetValues({alpha:1, y:m_sp.y+60});
			}*/
			m_ani.resetValues({alpha:1, scaleX:1,scaleY:1});
			m_ani.duration = 0.6;
			m_ani.ease = Exponential.easeIn;
			m_ani.onEnd = onStep1End;
			m_ani.begin();		
			super.begin();		
		}
		
		private function onStep1End():void
		{
			m_aniPause.sprite = m_sp;
			m_aniPause.delay = 1;
			m_aniPause.onEnd = onStep2End;
			m_aniPause.begin();
		}		
		
		private function onStep2End():void
		{		
			if(FightEn.NTUp == m_type)
			{
				m_ani.resetValues({alpha:0, y:m_sp.y-200});
			}
			else
			{
				m_ani.resetValues({alpha:0, y:m_sp.y+200});	
			}
			m_ani.duration = 1.2;		
			m_ani.ease = Exponential.easeOut;
			m_ani.onEnd = onStep3End;
			m_ani.begin();
		}
		
		private function onStep3End():void
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