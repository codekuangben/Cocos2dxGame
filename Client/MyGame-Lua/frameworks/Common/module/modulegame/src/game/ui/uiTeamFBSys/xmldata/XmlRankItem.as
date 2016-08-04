package game.ui.uiTeamFBSys.xmldata 
{
	/**
	 * @author ...
	 */
	public class XmlRankItem
	{		
		public var m_min:uint;
		public var m_max:uint;
		public var m_objid:uint;
		public var m_text:String;
		
		public function parseXml(xml:XML):void
		{
			m_min = int(xml.@min);
			m_max = int(xml.@max);
			m_objid = int(xml.@objid);
			m_text = xml.@text;
		}
	}
}