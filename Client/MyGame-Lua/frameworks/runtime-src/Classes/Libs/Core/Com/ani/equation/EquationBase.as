package com.ani.equation 
{
	
	/**
	 * ...
	 * @author 
	 */
	public class EquationBase
	{
		protected var m_tInit:Number;
		protected var m_tEnd:Number;
		protected var m_t:Number;
		protected var m_xOffset:Number;
		protected var m_yOffset:Number;
		public function EquationBase():void
		{
			
		}
		
		public function reset():void
		{
			t = m_tInit;
		}
		public function set t(v:Number):void
		{
			m_t = v;
		}
		public function get t():Number
		{
			return m_t;
		}
		public function set tInit(v:Number):void
		{
			m_tInit = v;
		}
		
		public function get tInit():Number
		{
			return m_tInit;
		}
		
		public function set tEnd(v:Number):void
		{
			m_tEnd = v;
		}
		public function get tEnd():Number
		{
			return m_tEnd;
		}
		
		public function get x():Number
		{
			return 0;
		}
		public function get y():Number
		{
			return 0;
		}
		
		
		public function set xOffset(v:Number):void
		{
			m_xOffset = v;
		}
		public function set yOffset(v:Number):void
		{
			m_yOffset = v;
		}
	}
	
}