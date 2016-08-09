package modulecommon.scene.benefithall.peoplerank 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class RankRewardObj 
	{
		public var m_id:uint;
		public var m_num:uint;
		public var m_upgrade:uint;
		public var m_enchance:uint;
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_num = parseInt(xml.@num);
			m_upgrade = parseInt(xml.@upgrade);
			m_enchance = parseInt(xml.@enchance);
		}
		
	}

}