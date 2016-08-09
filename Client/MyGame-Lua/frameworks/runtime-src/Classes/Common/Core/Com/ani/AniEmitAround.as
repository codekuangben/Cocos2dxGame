package com.ani 
{
	/**
	 * ...
	 * @author 
	 * 向四周发射
	 */
	import com.ani.equation.EquationBezierCurve1;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.GTween;
	public class AniEmitAround extends DigitAniBase 
	{
		private var m_gtWeen:GTween;
		private var m_equation:EquationBezierCurve1;	
		
		private var m_angleMin:Number;
		private var m_angleMax:Number;
		private var m_rangeMin:Number;
		private var m_rangeMax:Number;
		private var m_duration:Number;	
		public function AniEmitAround() 
		{
			m_gtWeen = new GTween();		
			m_gtWeen.autoPlay = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.target = this;
			m_gtWeen.paused = true;
			m_gtWeen.ease = Exponential.easeOut;
			m_equation = new EquationBezierCurve1();
		}
		/*angleMin, angleMax 发射的角度范围
		 * rangeMin, rangeMax: 发射的距离范围
		 * duration:一次波动需要的时间		
		 */ 
		public function setParam(angleMin:Number, angleMax:Number,rangeMin:Number, rangeMax:Number, duration:Number):void
		{
			m_angleMin = angleMin;
			m_angleMax = angleMax;
			m_rangeMin = rangeMin;
			m_rangeMax = rangeMax;
			m_duration = duration;			
		}
		override public function begin():void
		{
			var angle:Number = m_angleMin + (m_angleMax - m_angleMin) * Math.random();
			var range:Number= m_rangeMin+(m_rangeMax - m_rangeMin) * Math.random();
			var xEnd:Number = m_sp.x + Math.cos(angle)*range;
			var yEnd:Number = m_sp.y + Math.sin(angle)*range;
			
			m_equation.setPos(m_sp.x, m_sp.y, xEnd, yEnd);
			m_equation.t = 0;
			
			m_gtWeen.setValue("t", 1);
			m_gtWeen.duration = m_duration;
			m_gtWeen.paused = false;
			super.begin();
		}
		override public function stop():void
		{
			super.stop();
			m_gtWeen.paused = true;
		}
		override public function dispose():void 
		{
			m_gtWeen.paused = true;
			m_gtWeen.onComplete = null;
			m_gtWeen.target = null;
			m_gtWeen = null;
			super.dispose();
		}
		
		public function set t(v:Number):void
		{
			m_equation.t = v;
			m_sp.x = m_equation.x;
			m_sp.y = m_equation.y;
		}
		public function get t():Number
		{
			return m_equation.t;
		}		
		
		public function set ease(ease:Function):void
		{
			m_gtWeen.ease = ease;
		}
	}

}