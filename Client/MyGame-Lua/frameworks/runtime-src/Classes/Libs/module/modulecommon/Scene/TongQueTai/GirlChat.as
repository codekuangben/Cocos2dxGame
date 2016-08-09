package modulecommon.scene.tongquetai 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class GirlChat 
	{
		public var m_text:String;
		public var m_pertime:int;
		public var m_tottime:int;
		public function GirlChat() 
		{
			
		}
		public function parse(xml:XML):void
		{			
			m_text = UtilXML.attributeValue(xml, "text");
			m_pertime = UtilXML.attributeIntValue(xml, "pertime");
		}
	}

}