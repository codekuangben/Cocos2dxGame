package game.ui.uimysteryshop 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class CommodityMoney extends CommodityBase 
	{
		public var m_type:int;
		public var m_num:int;
		
		public function CommodityMoney() 
		{	
			super();
		}
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_type = UtilXML.attributeIntValue(xml, "type");
			m_num = UtilXML.attributeIntValue(xml, "num");
		}
	}
}