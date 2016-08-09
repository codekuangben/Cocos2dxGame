package modulecommon.scene.treasurehunt 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class treasureInfo 
	{
		public var m_id:uint;
		public var m_icon:String;
		public var m_desc:String;
		public function treasureInfo() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_icon = xml.@icon;
			m_desc = xml.toString();
		}
	}

}