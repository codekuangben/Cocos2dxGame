package game.ui.tasktrace.yugaogongneng 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	/**
	 * ...
	 * @author ...
	 */
	public class YugaoData 
	{
		private var m_gkContext:GkContext
		private var m_dicData:Dictionary;
		private var m_yugaoItem:YugaoItem;
		
		public function YugaoData(gk:GkContext, panel:YugaoItem) 
		{
			m_gkContext = gk;
			m_yugaoItem = panel;
			
		}
		
		public function get isLoaded():Boolean
		{
			return m_dicData != null;
		}
		
		public function parse(xml:XML):void
		{
			m_dicData = new Dictionary();
			var xmlList:XMLList;
			var xmlItem:XML;
			var itemData:GongnengItem;
			xmlList = xml.child("item");
			for each(xmlItem in xmlList)
			{
				itemData = new GongnengItem();
				itemData.parse(xmlItem);
				m_dicData[itemData.m_id] = itemData;
			}
		}
		
		public function dispose():void
		{
			
		}
		
		public function loadXML():void
		{
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Yugaogongneng);
			onLoaded(xml);
		}
		
		private function onLoaded(xml:XML):void
		{
			parse(xml);
			m_yugaoItem.updateDisplay();
		}
		
		public function getGongnengItem(id:int):GongnengItem
		{
			return m_dicData[id];
		}
		
	}

}