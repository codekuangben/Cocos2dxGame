package game.ui.uimysteryshop
{
	/**
	 * @brief 一项物品信息
	 */
	import com.util.UtilXML;
	import game.ui.uimysteryshop.xml.XmlLevelLabel;
	public class CommodityBase 
	{
		public static const GOT_MONEY:int = 1;
		public static const GOT_OBJ:int = 2;
		public static const GOT_WUXUE:int = 3;
		public static const GOT_HERO:int = 4;
		
		public var m_price:int;
		public var m_discountprice:int;
		//public var m_viplevel:int;
		public var m_discountlevel:int;
		public var m_name:String;
		public var m_namecolor:int;
		public var m_id:int;
		
		public var m_lvlLabel:XmlLevelLabel;

		public function CommodityBase() 
		{
			
		}
		public function parse(xml:XML):void
		{			
			m_price = UtilXML.attributeIntValue(xml, "price");
			m_discountprice = UtilXML.attributeIntValue(xml, "discountprice");
			//m_viplevel = UtilXML.attributeIntValue(xml, "viplevel");
			m_discountlevel = UtilXML.attributeIntValue(xml, "discountlevel");
			m_name = UtilXML.attributeValue(xml, "name");
			m_namecolor = UtilXML.attributeIntValue(xml, "color");
			m_id = UtilXML.attributeIntValue(xml, "id");
		}
		
		public function get type():int
		{
			var ret:int;
			if (this is CommodityMoney)
			{
				ret = GOT_MONEY;
			}
			else if (this is CommodityObject)
			{
				ret = GOT_OBJ;
			}
			else if (this is CommodityWuxue)
			{
				ret = GOT_WUXUE;
			}
			else if (this is CommodityHero)
			{
				ret = GOT_HERO;
			}
			else
			{				
			}
			return ret;
		}
	}
}