package com.ani.equation 
{
	/**
	 * ...
	 * @author 
	 * 反函数：其参数方程：
	 * 		x = t*m_xScale;
	 * 		y = t^m_pow * m_yScale
	 * 
	 * 		
	 */
	public class EquationInverse extends EquationBase 
	{
		protected var m_xScale:Number;
		protected var m_yScale:Number;
		protected var m_pow:Number;		
		
		public function EquationInverse()
		{
			
			m_xScale = 1;
			m_yScale = 1;
			m_pow = 1;
		}
		override public function get x():Number
		{
			return m_t*m_xScale + m_xOffset;
		}
		
		override public function get y():Number
		{
			return Math.pow(m_t, m_pow) * m_yScale + m_yOffset;			
		}
		
		public function set xScale(v:Number):void
		{
			m_xScale = v;
		}		
		
		public function set yScale(v:Number):void
		{
			m_yScale = v;
		}
		
		public function set pow(v:Number):void
		{
			m_pow = v;
		}
	
	}

}