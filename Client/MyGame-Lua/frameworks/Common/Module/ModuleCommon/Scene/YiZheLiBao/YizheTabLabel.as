package modulecommon.scene.yizhelibao 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class YizheTabLabel 
	{
		public static const CommondityType_Object:int = 0;	//道具
		public var m_iOpenlevel:int;
		public var m_strSlogan:String;
		public var m_id:int;
		public var m_list:Array;
		public function YizheTabLabel() 
		{
			
		}
		
		public function parse(xml:XML):void
		{
			m_list = new Array();
			m_iOpenlevel = UtilXML.attributeIntValue(xml, "openlevel");
			m_strSlogan = UtilXML.attributeValue(xml, "slogan");
			m_id = UtilXML.attributeIntValue(xml, "id");
			
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
				m_list.push(commodity);
				commodity.curTabLabel = this;
			}
			
		}
		
	}

}