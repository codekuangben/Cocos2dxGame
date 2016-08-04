package modulecommon.scene.benefithall.qiridenglu 
{
	import modulecommon.scene.prop.object.ObjectConfig;
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class Qiri_DayObject extends ObjectConfig 
	{
		public var m_effect:int;		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);		
			m_effect = UtilXML.attributeIntValue(xml, "effect");
		}
		
	}

}