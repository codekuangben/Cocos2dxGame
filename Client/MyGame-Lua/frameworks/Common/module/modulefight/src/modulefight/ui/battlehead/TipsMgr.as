package modulefight.ui.battlehead 
{
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	/**
	 * ...
	 * @author 
	 */
	public class TipsMgr 
	{
		private var m_gkContext:GkContext;
		private var m_StrOfLevel:Array;	
		public function TipsMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_StrOfLevel = new Array();
		}
		public function loadConfig():void
		{
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Fighttips);
			for each(var tabXml:XML in xml.child("level"))
			{
				var item:TipsString = new TipsString();
				item.parse(tabXml);
				m_StrOfLevel.push(item);
			}
		}
		public function getString():String
		{
			var str:String;
			for (var i:int = 0; i < m_StrOfLevel.length; i++ )
			{
				if (m_StrOfLevel[i].accordLevel(m_gkContext.m_mainPro.level))
				{
					str = m_StrOfLevel[i].getString();
				}
			}
			return str;
		}
	}

}