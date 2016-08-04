package modulecommon.scene.benefithall.peoplerank 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class Ranks_Style1 extends RanksBase
	{	
		public var m_fixRwards:Array;
		override public function parseXml(xml:XML):void
		{
			super.parseXml(xml);
			
			m_fixRwards = new Array();
	
			var itemXml:XML;
			var itemFixReward:FixReward;
			var list:XMLList = UtilXML.getChildXmlList(xml, "fixlevelreward");
			for each(itemXml in list)
			{
				itemFixReward = new FixReward();
				itemFixReward.parseXml(itemXml);
				m_fixRwards.push(itemFixReward);
			}
		}
		
	}

}