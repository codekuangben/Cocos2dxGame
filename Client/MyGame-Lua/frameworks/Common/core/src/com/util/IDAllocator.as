package com.util 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class IDAllocator 
	{
		private var m_beginID:uint;
		private var m_endID:uint;
		private var m_dicID:Dictionary
		public function IDAllocator() 
		{
			m_dicID = new Dictionary();
		}
		public function set beginID(id:uint):void
		{
			m_beginID = id;
		}
		public function set endID(id:uint):void
		{
			m_endID = id;
		}
		public function allocate():uint
		{
			var i:int;
			var id:uint = m_beginID;
			for (id = m_beginID; id < m_endID; id++)
			{
				if (m_dicID[id] == undefined)
				{
					m_dicID[id] = 1;
					return id;
				}
				
			}
			return 0;
		}
		public function retrieve(id:uint):void
		{
			if (m_dicID[id] != undefined)
			{
				delete m_dicID[id];
			}
		}
		
		
	}

}