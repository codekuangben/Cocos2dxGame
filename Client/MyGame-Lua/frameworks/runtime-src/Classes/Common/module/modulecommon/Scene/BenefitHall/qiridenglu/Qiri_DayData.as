package modulecommon.scene.benefithall.qiridenglu 
{
	import com.util.UtilXML;
	import modulecommon.scene.prop.object.ObjectConfig;
	/**
	 * ...
	 * @author 
	 */
	public class Qiri_DayData
	{	
		public var m_id:int;
		public var m_x:int;
		public var m_y:int;
		public var m_xView:int;
		public var m_yView:int;
		public var m_scaleView:Number;
		public var m_bMirror:Boolean;
		
		public var m_name:String;
		public var m_awardList:Array;		
		public function parseXML(xml:XML):void
		{
			m_id = UtilXML.attributeIntValue(xml, "id");
			m_x = UtilXML.attributeIntValue(xml, "xicon");
			m_y = UtilXML.attributeIntValue(xml, "yicon");
			
			m_xView = UtilXML.attributeIntValue(xml, "xview");
			m_yView = UtilXML.attributeIntValue(xml, "yview");
			m_scaleView = UtilXML.attributeIntValue(xml, "scaleview") / 100;
			m_bMirror = UtilXML.attributeIntValue(xml, "mirror") == 1?true:false;
			m_name = UtilXML.attributeValue(xml, "name");
			
			m_awardList = new Array();
			var list:XMLList = UtilXML.getChildXmlList(xml, "obj");
			var itemXml:XML;
			var itemObj:Qiri_DayObject;
			for each(itemXml in list)
			{
				itemObj = new Qiri_DayObject();
				itemObj.parseXML(itemXml);
				m_awardList.push(itemObj);
			}
		}
		
	}

}