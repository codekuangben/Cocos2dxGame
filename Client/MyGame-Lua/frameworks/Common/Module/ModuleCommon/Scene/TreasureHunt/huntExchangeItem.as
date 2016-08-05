package modulecommon.scene.treasurehunt 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class huntExchangeItem 
	{
		public var m_id:uint;
		//public var m_num:uint;
		public var m_score:uint;
		public function huntExchangeItem() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			//m_num = parseInt(xml.@num);
			m_score = parseInt(xml.@price);
		}
	}

}