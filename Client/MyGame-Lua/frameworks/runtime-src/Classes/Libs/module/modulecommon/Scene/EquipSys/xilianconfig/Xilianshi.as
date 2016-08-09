package modulecommon.scene.equipsys.xilianconfig 
{
	/**
	 * ...
	 * @author 
	 */
	public class Xilianshi 
	{		
		public var m_id:uint;
		public var m_num:uint;	
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_num = parseInt(xml.@num);
		}
	}

}