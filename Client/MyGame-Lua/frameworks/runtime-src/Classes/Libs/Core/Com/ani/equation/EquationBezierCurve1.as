package com.ani.equation 
{
	import org.ffilmation.utils.mathUtils;
	/**
	 * ...
	 * @author 
	 * 一次方贝塞尔曲线
	 */
	public class EquationBezierCurve1  extends EquationBase 
	{
		private var m_xPS:Number;
		private var m_yPS:Number;		
		private var m_xPD:Number;
		private var m_yPD:Number;
		
		private var m_x:Number;
		private var m_y:Number;
		public function EquationBezierCurve1() 
		{
			m_tInit = 0;
			m_tEnd = 1;
		}
		public function setPos(xS:Number, yS:Number,xD:Number, yD:Number):void
		{
			m_xPS = xS;
			m_yPS = yS;
			
			m_xPD = xD;
			m_yPD = yD;
		}
		public function setPS(x:Number, y:Number):void
		{
			m_xPS = x;
			m_yPS = y;
		}
		public function setPD(x:Number, y:Number):void
		{
			m_xPD = x;
			m_yPD = y;
		}
		
		public function distance():Number
		{
			return mathUtils.distance(m_xPS,m_yPS,m_xPD,m_yPD);
		}
		override public function set t(value:Number):void 
		{
			super.t = value;
			
			var a:Number = (1 - t);
			
			m_x = a * m_xPS;
			m_y = a * m_yPS;
			
			
			m_x += t * m_xPD;
			m_y += t * m_yPD;			
		}
		
		override public function get x():Number
		{
			return m_x;
		}
		override public function get y():Number
		{
			return m_y;
		}
	}

}