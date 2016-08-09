package modulecommon.scene.treasurehunt  
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class treasureInfoList 
	{
		public var m_minLevel:uint;
		public var m_maxLevel:uint;
		public var m_treasureInfoList:Array;
		public function treasureInfoList() 
		{
			m_treasureInfoList = new Array();
		}
		public function parse(xml:XML):void
		{
			m_minLevel = parseInt(xml.@minlevel);
			m_maxLevel = parseInt(xml.@maxlevel);
			var tabXml:XML;
			for each(tabXml in xml.elements("*"))
			{
				var item:treasureInfo = new treasureInfo();
				item.parse(tabXml);
				m_treasureInfoList.push(item);
			}
		}
	}

}