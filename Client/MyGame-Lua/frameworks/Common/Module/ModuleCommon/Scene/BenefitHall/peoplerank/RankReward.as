package modulecommon.scene.benefithall.peoplerank 
{
	/**
	 * ...
	 * @author 
	 */
	
	import com.util.UtilXML;
	public class RankReward 
	{
		public var m_fromrank:int;
		public var m_torank:int;
		public var m_tip:String;
		public var m_obj:RankRewardObj;
		public function parseXml(xml:XML):void
		{
			m_fromrank = UtilXML.attributeIntValue(xml, "fromrank");
			m_torank = UtilXML.attributeIntValue(xml, "torank");
			m_tip = UtilXML.getTextOfSubNode(xml, "tip");
			var Xml:XML;
			for each(Xml in xml.child("obj"))
			{
				m_obj = new RankRewardObj();
				m_obj.parseXml(Xml);
			}
		}
		
	}

}