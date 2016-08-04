package game.ui.uimysteryshop.xml
{
	import game.ui.uimysteryshop.CommodityBase;
	import game.ui.uimysteryshop.CommodityHero;
	import game.ui.uimysteryshop.CommodityMoney;
	import game.ui.uimysteryshop.CommodityObject;
	import game.ui.uimysteryshop.CommodityWuxue;
	/**
	 * @brief 对应 xml 配置文件中的 levelrange 标签
	 */
	public class XmlLevelLabel 
	{
		public var m_id:uint;
		public var m_minlevel:uint;
		public var m_maxlevel:uint;
		public var m_list:Array;
		
		public function getdate(id:uint):CommodityBase
		{
			for each(var item:CommodityBase in m_list)
			{
				if (item.m_id == id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_minlevel = parseInt(xml.@minlevel);
			m_maxlevel = parseInt(xml.@maxlevel);
			
			m_list = new Array();
			
			var itemXML:XML;
			var commodity:CommodityBase;
			for each(itemXML in xml.elements("*"))
			{
				switch (itemXML.localName())
				{
					case "money":
						commodity = new CommodityMoney();
						commodity.parse(itemXML);
						break;
					case "obj":
						commodity = new CommodityObject();
						commodity.parse(itemXML);
						break;
					case "wuxue":
						commodity = new CommodityWuxue();
						commodity.parse(itemXML);
						break;
					case "hero":
						commodity = new CommodityHero();
						commodity.parse(itemXML);
						break;
					default:
				}
				commodity.m_lvlLabel = this;
				m_list.push(commodity);
			}
		}
	}
}