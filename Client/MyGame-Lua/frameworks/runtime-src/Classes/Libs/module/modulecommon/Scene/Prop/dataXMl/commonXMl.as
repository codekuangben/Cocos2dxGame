package modulecommon.scene.prop.dataXMl 
{
	/**
	 * ...
	 * @author 
	 */
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;	
	import com.util.DebugBox;
	import com.util.UtilXML;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	public class commonXMl 
	{
		private var m_gkContext:GkContext;
		private var m_data:Dictionary;
		public function commonXMl(gk:GkContext) 
		{
			m_gkContext = gk;
			
		}
		private function loadConfig():void
		{			
			m_data = new Dictionary();
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Common);
			var itemXML:XML;
			var id:int;
			var list:XMLList = xml.child("index");
			for each(itemXML in list)
			{
				id = UtilXML.attributeIntValue(itemXML, "id");
				m_data[id] = itemXML;
			}			
		}
		
		public function getItem(id:int):XML
		{
			if (m_data == null)
			{
				loadConfig();
			}
			var ret:XML = m_data[id];
			if (ret == null)
			{
				var str:String = "common.xml缺少编号为"+id+"的记录";
				DebugBox.info(str);
			}
			return ret;
		}
		
		public function deleteItem(id:int):void
		{
			delete m_data[id];
		}
		
	}

}