package com.ani.equation 
{
	//import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 * 二次方贝塞尔曲线
	 * 设定m_xPS等变量的值只能由通过调用setPS等函数进行
	 * 
	 */
	public class EquationBezierCurve2 extends EquationBase 
	{
		public var m_xPS:Number;
		public var m_yPS:Number;
		public var m_xP:Number;
		public var m_yP:Number;
		public var m_xPD:Number;
		public var m_yPD:Number;
		
		private var m_x:Number;
		private var m_y:Number;
		public function EquationBezierCurve2() 
		{
			m_tInit = 0;
			m_tEnd = 1;
		}
		
		public function setPS(x:Number, y:Number):void
		{
			m_xPS = x;
			m_yPS = y;
		}
		public function setP(x:Number, y:Number):void
		{
			m_xP = x;
			m_yP = y;
		}
		
		public function setPD(x:Number, y:Number):void
		{
			m_xPD = x;
			m_yPD = y;
		}
		override public function set t(value:Number):void 
		{
			super.t = value;
			
			var a:Number = (1 - t);
			var b:Number = a * a;
			m_x = b * m_xPS;
			m_y = b * m_yPS;
			
			b = 2 * t * a;
			m_x += b * m_xP;
			m_y += b * m_yP;
			
			b = t * t;
			m_x += b * m_xPD;
			m_y += b * m_yPD;				
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