package game.ui.uiTeamFBSys.xmldata 
{
	/**
	 * ...
	 * @author ...
	 */
	public class XmlBossRewardItem 
	{		
		public var m_bossID:uint;
		public var m_siliver:uint;
		
		public function parseXml(xml:XML):void
		{
			m_bossID = int(xml.@id);
			m_siliver = int(xml.@siliver);
		}
	}
}