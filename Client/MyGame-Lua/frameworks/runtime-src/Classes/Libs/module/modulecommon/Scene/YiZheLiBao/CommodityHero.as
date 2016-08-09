package modulecommon.scene.yizhelibao 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class CommodityHero extends CommodityBase 
	{
		public var m_rebirth:int;
		public var m_heroid:int;
		
		public function CommodityHero() 
		{
			super();
		}
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_heroid = UtilXML.attributeIntValue(xml, "heroid");
			m_rebirth = UtilXML.attributeIntValue(xml, "rebirth");
		}
	}

}