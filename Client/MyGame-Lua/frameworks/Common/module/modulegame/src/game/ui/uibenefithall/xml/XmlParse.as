package game.ui.uibenefithall.xml
{
	/**
	 * @brief xml 解析
	 */
	public class XmlParse 
	{
		public var m_xmlData:XmlData;

		public function XmlParse(xmlData:XmlData)
		{
			m_xmlData = xmlData;
		}
		
		public function parseXml(xml:XML):void
		{
			var activeList:XMLList;
			var activeXML:XML;
			var xmlactivedata:XmlJLZHActiveIteam;
			
			activeList = xml.child("active");
			for each(activeXML in activeList)
			{
				xmlactivedata = new XmlJLZHActiveIteam();
				xmlactivedata.parseXml(activeXML);
				m_xmlData.m_activeLst.push(xmlactivedata);
			}
		}
	}
}