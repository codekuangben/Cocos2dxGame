package game.ui.uipaoshangsys.xml
{
	import flash.geom.Point;
	import org.ffilmation.utils.mathUtils;
	/**
	 * @brief 线段
	 */
	public class XmlSegm 
	{
		public var m_startPt:Point;
		public var m_endPt:Point;
		public var m_len:Number;
		
		public function calcLen():Number
		{
			m_len = mathUtils.distance(m_startPt.x, m_startPt.y, m_endPt.x, m_endPt.y);
			return m_len;
		}
	}
}