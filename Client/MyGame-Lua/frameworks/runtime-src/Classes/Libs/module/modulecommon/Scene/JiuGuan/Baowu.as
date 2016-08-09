package modulecommon.scene.jiuguan 
{
	/**
	 * ...
	 * @author 
	 */
	public class Baowu 
	{
		public var m_id:uint;
		public var m_num:uint;
		public function Baowu() 
		{
			m_id = 0;
			m_num = 0;
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_num = parseInt(xml.@num);
		}
	}

}