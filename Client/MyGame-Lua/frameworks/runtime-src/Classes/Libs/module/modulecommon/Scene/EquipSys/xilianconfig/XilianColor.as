package modulecommon.scene.equipsys.xilianconfig 
{
	/**
	 * ...
	 * @author 
	 */
	public class XilianColor 
	{		
		public var m_color:int;	//见定义ZObjectDef.COLOR_WHITE
		public var m_xilian:Xilianshi;
		public var m_fenjie:Xilianshi;
		
		public function parseXml(xml:XML):void
		{
			m_color= parseInt(xml.@id);
			m_xilian = new Xilianshi();
			m_fenjie = new Xilianshi();
			
			var xilianXML:XML = xml.child("xilian")[0];
			m_xilian.parseXml(xilianXML);
			
			var fenjieXML:XML = xml.child("fenjie")[0];
			m_fenjie.parseXml(fenjieXML);
		}
	}

}