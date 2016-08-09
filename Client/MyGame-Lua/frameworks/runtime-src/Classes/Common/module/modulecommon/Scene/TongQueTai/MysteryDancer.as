package modulecommon.scene.tongquetai 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class MysteryDancer extends DancerBase
	{
		public var m_maxnum:int;
		public var m_notStolen:int;
		public function MysteryDancer() 
		{
			super();
		}
		
		public override function parse(xml:XML):void
		{
			super.parse(xml);
			m_maxnum = UtilXML.attributeIntValue(xml, "maxnum");
			m_notStolen = UtilXML.attributeIntValue(xml, "notStolen");
		}
	}

}