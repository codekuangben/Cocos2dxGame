package com.ani 
{
	/**
	 * ...
	 * @author 
	 */
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.GTween;
	//import flash.geom.Point;
	import org.ffilmation.utils.mathUtils;
	
	public class AniPosition extends DigitAniBase 
	{
		private var m_gtWeen:GTween;
		protected var m_xBegin:Number;
		protected var m_yBegin:Number;
		
		protected var m_xEnd:Number;
		protected var m_yEnd:Number;
		protected var m_duration:Number;
		protected var m_ease:Function;
		public function AniPosition() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.paused = true;			
			m_gtWeen.useFrames = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;
			m_ease = Linear.easeNone;
		}
		
		public function setBeginPos(x:Number, y:Number):void
		{
			m_xBegin = x;
			m_yBegin = y;
		}
		
		public function setEndPos(x:Number, y:Number):void
		{
			m_xEnd = x;
			m_yEnd = y;
		}
		public function set duration(t:Number):void
		{
			m_duration = t;
		}
		public function set ease(ease:Function):void
		{
			m_ease = ease;
		}
		public function set speed(s:Number):void
		{
			m_duration = mathUtils.distance(m_xBegin, m_yBegin, m_xEnd, m_yEnd) / s;
		}
		public function set repeatCount(count:int):void
		{
			m_gtWeen.repeatCount = count;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			m_gtWeen.onComplete = null;
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
		}
		
		override public function begin():void
		{
			m_sp.x = m_xBegin;
			m_sp.y = m_yBegin;
			m_gtWeen.target = m_sp;
			m_gtWeen.ease = m_ease;
			m_gtWeen.resetValues( { x:m_xEnd, y:m_yEnd } );
			m_gtWeen.init();
			m_gtWeen.duration = m_duration;
			m_gtWeen.paused = false;
			super.begin();
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
	}

}