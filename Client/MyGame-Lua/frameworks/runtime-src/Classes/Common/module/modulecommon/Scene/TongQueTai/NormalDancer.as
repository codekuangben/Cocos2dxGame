package modulecommon.scene.tongquetai 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class NormalDancer extends DancerBase
	{
		public var m_haogan:int;
		public var m_reqid:int;
		public var m_reqnum:int;
		public var m_bOwn:Boolean;	//true-拥有此舞女
		public function NormalDancer() 
		{
			super();
		}
		
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_haogan = UtilXML.attributeIntValue(xml, "haogan");
			m_reqid = UtilXML.attributeIntValue(xml, "reqid");
			m_reqnum = UtilXML.attributeIntValue(xml, "reqnum");
		}
		
	}

}