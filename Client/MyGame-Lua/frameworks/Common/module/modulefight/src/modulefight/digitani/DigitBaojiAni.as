package modulefight.digitani 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.ani.AniShake;
	//import com.gskinner.motion.easing.Back;
	//import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.GTween;
	//import flash.display.Sprite;
	import flash.geom.ColorTransform;
	//import flash.geom.Transform;
	import com.ani.DigitAniBase;
	
	public class DigitBaojiAni  extends DigitAniBase
	{
		private var m_gtWeen:GTween;
		private var m_shakeAni:AniShake;
		private var m_colorTransform:ColorTransform;
		private var m_colorOffset:Number = 0;
		
		public function DigitBaojiAni() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.paused = true;			
			m_gtWeen.useFrames = false;			
			m_gtWeen.repeatCount = 1;
			m_colorTransform = new ColorTransform();
			m_shakeAni = new AniShake();	
			m_shakeAni.setParam(-3.1415926 / 2, 15, 0.025, 2);
			m_shakeAni.onEnd = onStep2Complete;
		}		
		override public function begin():void
		{
		
			dScaleX = 0;
			dScaleY = 0;	
			dAlpha = 0;
			m_sp.transform.colorTransform = new ColorTransform();
			m_gtWeen.target = this;
			m_gtWeen.setValues({dY:m_sp.y - 60, dScaleX:1, dScaleY:1, dAlpha:1});			
			m_gtWeen.init();			
			
			m_gtWeen.onComplete = onStep1Complete;
			
			m_gtWeen.duration = 0.2;
			m_gtWeen.paused = false;	
			super.begin();
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
			m_shakeAni.stop();
		}
		protected function onStep1Complete(tween:GTween):void
		{
			m_shakeAni.sprite = m_sp;
			m_shakeAni.begin();
		}	
		
		protected function onStep2Complete():void
		{		
			m_gtWeen.resetValues( { dY:m_sp.y - 35, dAlpha:0, dScaleX:1.2, dScaleY:1.2} );//, colorOffset:120 
			m_gtWeen.init();
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.duration = 0.2;
			m_gtWeen.delay = 0.8;
			//m_gtWeen.ease = Back.easeIn;			
			m_gtWeen.paused = false;
		}
		
		override public function dispose():void 
		{
			m_shakeAni.dispose();
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen.onComplete = null;
			m_gtWeen = null;
			super.dispose();
		}
		public function set dScaleX(s:Number):void
		{
			m_sp.scaleX = s;			
			
		}
		public function get dScaleX():Number
		{
			return m_sp.scaleX;
		}
		public function set dScaleY(s:Number):void
		{
			m_sp.scaleY = s;			
		}
		
		public function get dScaleY():Number
		{
			return m_sp.scaleY;			
		}
		
		public function set dY(s:Number):void
		{
			m_sp.y = s;			
		}
		
		public function get dY():Number
		{
			return m_sp.y;
		}
		
		public function set dAlpha(s:Number):void
		{
			m_sp.alpha = s;			
		}
		
		public function get dAlpha():Number
		{
			return m_sp.alpha;
		}
		
		public function set colorOffset(s:Number):void
		{
			m_colorOffset = s;
			m_colorTransform.redOffset = m_colorTransform.greenOffset = m_colorTransform.blueOffset = m_colorOffset;
			m_colorTransform.alphaOffset = -1.9*m_colorOffset;
			
			
			m_sp.transform.colorTransform = m_colorTransform;		
			//trace(m_sp.transform.colorTransform.alphaOffset);
		}
		
		public function get colorOffset():Number
		{
			return m_colorOffset;
		}
	}

}