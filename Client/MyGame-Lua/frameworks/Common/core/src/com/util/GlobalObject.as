package com.util
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class GlobalObject
	{
		private var m_tf:TextField;
		private var m_filters:Array;
		public function GlobalObject() 
		{
			var filter:GlowFilter = new GlowFilter(0, 1, 2, 2, 16);
			m_filters = new Array();
			m_filters.push(filter);
		}
		
		public function get tf():TextField
		{
			if (m_tf == null)
			{
				m_tf = new TextField();
			}
			return m_tf;
		}
		public function get glowFilter():Array
		{
			return m_filters;
		}
		
	}

}