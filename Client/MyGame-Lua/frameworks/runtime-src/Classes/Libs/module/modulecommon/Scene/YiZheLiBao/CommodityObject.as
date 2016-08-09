package modulecommon.scene.yizhelibao 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class CommodityObject extends CommodityBase 
	{
		public var m_objid:int;
		public var m_num:int;
		public var m_upgrade:int;
		public var m_enlevel:int;
		public function CommodityObject() 
		{
			super();			
		}
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_objid = UtilXML.attributeIntValue(xml, "objid");
			m_upgrade = UtilXML.attributeIntValue(xml, "upgrade");
			m_num = UtilXML.attributeIntValue(xml, "num");
			m_enlevel = UtilXML.attributeIntValue(xml, "enlevel");
		}
	}

}