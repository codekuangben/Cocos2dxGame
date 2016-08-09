package org.ffilmation.engine.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 * This event is dispatched whenever the fCell of an element changes.
	 */
	public class fNewCellEvent extends Event 
	{
		public var m_needDepthSort:Boolean;	//dispatch本事件时，需要深度排序
		public function fNewCellEvent(type:String, bNotDepthSort:Boolean = true)
		{
			super(type);	
			m_needDepthSort = bNotDepthSort;
		}
		
	}

}