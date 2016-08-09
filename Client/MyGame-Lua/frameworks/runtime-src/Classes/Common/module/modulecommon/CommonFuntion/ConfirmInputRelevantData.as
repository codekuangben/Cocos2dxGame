package modulecommon.commonfuntion 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class ConfirmInputRelevantData 
	{
		public var m_pos:Point;
		public var m_func:Function;
		public var m_color:uint;
		
		public function ConfirmInputRelevantData(pos:Point, func:Function, color:uint) 
		{
			m_pos = pos;
			m_func = func;
			m_color = color;
		}
		
	}

}