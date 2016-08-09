package modulecommon.scene.zhanxing 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class WuxueData 
	{
		public var m_id:uint;
		public var m_price:uint;
		public function WuxueData() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = UtilXML.attributeIntValue(xml, "id");
			m_price = UtilXML.attributeIntValue(xml, "score");
		}
	}

}