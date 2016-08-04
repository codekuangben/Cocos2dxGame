package game.ui.uibenefithall.xml
{
	/**
	 * @brief 每一项活动内容
	 */
	public class XmlJLZHActiveIteam 
	{
		public var m_id:uint;
		public var m_picPath:String;
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_picPath = xml.@picname;
		}
	}
}