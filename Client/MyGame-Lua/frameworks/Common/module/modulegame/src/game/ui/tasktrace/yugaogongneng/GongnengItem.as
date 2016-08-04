package game.ui.tasktrace.yugaogongneng 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author ...
	 */
	public class GongnengItem 
	{
		public var m_id:int;
		public var m_iconpath:String;
		public var m_condition:String;
		public var m_briefdesc:String;
		public var m_desc:String;
		public function GongnengItem() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = xml.@id;
			m_iconpath = xml.@iconpath;
			m_condition = xml.@condition;
			m_briefdesc = UtilXML.getTextOfSubNode(xml, "briefdesc");
			m_desc = UtilXML.getTextOfSubNode(xml, "desc");			
		}
		
	}

}