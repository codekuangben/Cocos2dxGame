package game.ui.uimysteryshop 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class CommodityWuxue extends CommodityBase 
	{
		public var m_wxid:int;
		public function CommodityWuxue() 
		{
			super();
			
		}
		
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_wxid = UtilXML.attributeIntValue(xml, "wxid");
		}
	}
}