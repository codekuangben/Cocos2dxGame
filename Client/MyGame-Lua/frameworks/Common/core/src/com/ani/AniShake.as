package com.ani 
{
	/**
	 * ...
	 * @author 
	 * 震动
	 */
	import com.ani.equation.EquationBezierCurve1;
	import com.gskinner.motion.GTween;
	public class AniShake extends DigitAniBase 
	{
		private var m_gtWeen:GTween;
		private var m_equation:EquationBezierCurve1;	
		
		private var m_angle:Number;
		private var m_range:Number;
		private var m_duration:Number;	
		public function AniShake() 
		{
			m_gtWeen = new GTween();
			m_gtWeen.reflect = true;
			m_gtWeen.autoPlay = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.target = this;
			m_gtWeen.paused = true;
			m_equation = new EquationBezierCurve1();
			
		}
		/*angle:震动的角度
		 * range: 震动的幅度
		 * duration:一次波动需要的时间
		 * times: 波动次数，从A点到B点，再回到A点，表示一次波动。
		 */ 
		public function setParam(angle:Number, range:Number, duration:Number, times:int ):void
		{
			m_angle = angle;
			m_range = range;
			m_duration = duration;
			m_gtWeen.repeatCount = times + times;
		}
		override public function begin():void
		{
			var xEnd:Number = m_sp.x + Math.cos(m_angle)*m_range;
			var yEnd:Number = m_sp.y + Math.sin(m_angle)*m_range;
			
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
	}

}