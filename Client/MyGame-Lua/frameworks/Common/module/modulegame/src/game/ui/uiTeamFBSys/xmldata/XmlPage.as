package game.ui.uiTeamFBSys.xmldata
{
	/**
	 * @brief 一个叶签的内容
	 * */
	public class XmlPage
	{
		//public var m_id:uint;
		public var m_name:String;
		public var m_lvl:uint;
		//public var m_itemLst:Vector.<XmlFBItem>;
		public var m_itemLst:Array;
		
		public function parseXml(xml:XML):void
		{
			//m_itemLst = new Vector.<XmlFBItem>();
			m_itemLst = [];
			
			//m_id = parseInt(xml.@id);
			m_name = xml.@name;
			m_lvl = xml.@level;

			var listXML:XMLList = xml.child("copy");
			var i:int;
			var fbItem:XmlFBItem;
			var copyidx:uint = 0;
			for (i = 0; i < listXML.length(); i++)
			{
				if(copyidx == 0)
				{
					fbItem = new XmlFBItem();
					fbItem.parseXml(listXML[i], copyidx);
					m_itemLst.push(fbItem);
					++copyidx;
				}
				else
				{
					fbItem.parseXml(listXML[i], copyidx);
					copyidx = 0;
				}
			}
		}
	}
}