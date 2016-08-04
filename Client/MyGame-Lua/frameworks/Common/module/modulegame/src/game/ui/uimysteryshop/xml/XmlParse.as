package game.ui.uimysteryshop.xml
{
	/**
	 * @brief xml 解析
	 */
	
	import com.util.UtilXML;
	import flash.utils.Dictionary;
	import game.ui.uimysteryshop.CommodityBase;
	import game.ui.uimysteryshop.CommodityHero;
	import game.ui.uimysteryshop.CommodityMoney;
	import game.ui.uimysteryshop.CommodityObject;
	import game.ui.uimysteryshop.CommodityWuxue;
	public class XmlParse 
	{
		public var m_XmlData:XmlData;
		
		public function XmlParse(data:XmlData) 
		{
			m_XmlData = data;
		}
		
		public function parse(xml:XML):void
		{
			m_XmlData.m_dicTablabel = new Dictionary();
			
			var levelXml:XML;
			var levelitem:XmlLevelLabel;
			var levelList:XMLList = xml.child("levelrange");
			for each(levelXml in levelList)
			{
				levelitem = new XmlLevelLabel();
				levelitem.parse(levelXml);
				m_XmlData.m_dicTablabel[levelitem.m_id] = levelitem;
			}
		}
	}
}