package modulecommon.scene.benefithall.peoplerank 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class FixReward 
	{
		public var m_id:int;
		public var m_level:int;
		public var m_tip:String;
		public function parseXml(xml:XML):void
		{
			m_id = UtilXML.attributeIntValue(xml, "id");
			m_level = UtilXML.attributeIntValue(xml, "level");
			m_tip = UtilXML.getTextOfSubNode(xml, "tip");		
		}
		
	}

}