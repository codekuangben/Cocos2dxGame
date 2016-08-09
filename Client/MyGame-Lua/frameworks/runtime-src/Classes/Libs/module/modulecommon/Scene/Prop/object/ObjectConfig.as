package modulecommon.scene.prop.object 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class ObjectConfig 
	{
		public var m_id:uint;
		public var m_num:uint;
		public var m_upgrade:uint;
		public function parseXML(xml:XML):void
		{
			m_id = UtilXML.attributeIntValue(xml, "id");
			m_num = UtilXML.attributeIntValue(xml, "num");
			m_upgrade = UtilXML.attributeIntValue(xml, "upgrade");
		}
		
	}

}