package com.bit101.components.controlList 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author 
	 * 1. 这是个队列，先进先出
	 * 2. m_queueSize表示队列的最大值。
	 */
	public class ControlListVHeight_queue extends ControlListVHeight 
	{
		private var m_queueSize:int;
		public function ControlListVHeight_queue(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
		}
		
		//当数据数量超过m_queueSize时，先删除第一个数据，然后再添加
		public function push(data:Object):void
		{
			if (m_controls.length == m_queueSize)
			{
				deleteDataWithoutAni(0);
			}
			insertData( -1, data);
		}
		public function set queueSize(s:int):void
		{
			m_queueSize = s;
		}
	}

}