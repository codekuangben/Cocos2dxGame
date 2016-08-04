package game.ui.uipaoshangsys.xml
{	
	import com.util.UtilXML;
	import flash.utils.Dictionary;
	
	/**
	 * @brief xml 解析
	 */
	
	public class XmlParse 
	{
		public var m_XmlData:XmlData;
		
		public function XmlParse(data:XmlData) 
		{
			m_XmlData = data;
		}
		
		public function parse(xml:XML):void
		{
			// 解析路径配置
			var pathXml:XML;
			pathXml = xml.child("path")[0];
			m_XmlData.m_xmlPath.parse(pathXml);
			
			// 解析其它配置
			var miscxml:XML = xml.child("misc")[0];
			// 解析顶级货物列表
			m_XmlData.parseTopGoodXml(miscxml);
			// 解析额外加成
			m_XmlData.parseExtraAdd(miscxml);
			// 解析随机货物
			m_XmlData.parseRandGood(miscxml);
			// 解析服务器类型到客户端id映射
			m_XmlData.parseType2ObjId(miscxml);
		}
	}
}