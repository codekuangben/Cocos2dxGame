package org.ffilmation.engine.helpers 
{
	import flash.geom.Point;
	/**
	 * @brief 偏移列表，可能只指定第一帧，后面所有的都用第一帧的，或者每一帧都指定，就这两种情况
	 */
	public class fOffList 
	{
		public var m_offLst:Vector.<Point>;

		public function fOffList() 
		{
			m_offLst = new Vector.<Point>();
		}
		
		public function copyFrom(rh:fOffList):void
		{
			var pt:Point;
			var tmp:Point;
			for each(pt in rh.m_offLst)
			{
				tmp = new Point(pt.x, pt.y);
				m_offLst.push(tmp);
			}
		}
		
		// 根据帧数生成列表
		public function buildLstByFrameCnt(framecnt:uint):void
		{
			m_offLst.length = 0;
			var idx:int = 0;
			while (idx < framecnt)
			{
				m_offLst.push(new Point());
				++idx;
			}
		}
	}
}