package com.ani 
{
	/**
	 * ...
	 * @author 
	 * 这是一个可以将Sprite对象移动的动画。移动轨迹是由参数方程确定、参数的取值范围确定的
	 */
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.ani.equation.EquationBase;	
	//import org.ffilmation.utils.mathUtils;
	
	public class AniPositionParamEquation extends DigitAniBase 
	{
		protected var m_gtWeen:GTween;
		protected var m_equation:EquationBase;
		protected var m_ease:Function;
		protected var m_duration:Number;
		protected var m_speed:Number=0;
		public function AniPositionParamEquation() 
		{
			m_gtWeen = new GTween();	
			m_gtWeen.target = this;
			m_gtWeen.paused = true;			
			m_gtWeen.useFrames = false;
			m_gtWeen.onComplete = onComplete;
			m_gtWeen.repeatCount = 1;
			m_ease = Linear.easeNone;
		}
		
		public function set equation(equation:EquationBase):void
		{
			m_equation = equation;
		}
		
		public function set duration(t:Number):void
		{
			m_duration = t;
		}
		
		public function set useFrames(b:Boolean):void
		{
			m_gtWeen.useFrames = b;
		}
		public function set ease(ease:Function):void
		{
			m_ease = ease;
		}
		public function set speed(s:Number):void
		{
			m_speed = s;
			
		}
		
		override public function dispose():void 
		{
			super.dispose();
			m_gtWeen.paused = true;
			m_gtWeen.target = null;
			m_gtWeen = null;
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
		
		override public function begin():void
		{
			m_equation.reset();
			m_sp.x = m_equation.x;
			m_sp.y = m_equation.y;			
			
			m_gtWeen.ease = m_ease;
			m_gtWeen.resetValues( { t:m_equation.tEnd} );
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