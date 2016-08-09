package modulecommon.scene.benefithall.peoplerank 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class RanksBase 
	{
		public var m_day:int;
		public var m_type:int;
		public var m_rankRwards:Array;
		public function RanksBase() 
		{
			
		}
		public function parseXml(xml:XML):void
		{
			m_day = UtilXML.attributeIntValue(xml, "id");
			m_type = UtilXML.attributeIntValue(xml, "type");			
		
			m_rankRwards = new Array();
			
			var list:XMLList = UtilXML.getChildXmlList(xml, "rankreward");
			var itemXml:XML;
			var itemObj:RankReward;
			for each(itemXml in list)
			{
				itemObj = new RankReward();
				itemObj.parseXml(itemXml);
				m_rankRwards.push(itemObj);
			}				
		}
	}

}