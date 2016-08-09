package modulecommon.scene.herorally 
{
	import flash.utils.Dictionary;
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class groupInfo 
	{
		public var m_id:uint;
		public var m_rankText:String;
		public var m_recordBoxTip:String;
		public var m_rankBoxTip:Dictionary;//[rank,tips]
		public function groupInfo() 
		{
			m_rankBoxTip = new Dictionary();
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_rankText = xml.@jiduan;
			m_recordBoxTip = xml.@boxtip;
			for each(var item:XML in xml.elements("rankreward"))
			{
				var rankNo:uint = parseInt(item.@id);
				var tip:String = item.@rankboxtip;
				m_rankBoxTip[rankNo] = tip;
			}
		}
		
	}

}