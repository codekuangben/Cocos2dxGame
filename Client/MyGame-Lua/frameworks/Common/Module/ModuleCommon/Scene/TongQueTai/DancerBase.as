package modulecommon.scene.tongquetai 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.UtilXML;
	public class DancerBase 
	{
		public static const GOT_NARMALDANCER:int = 1;
		public static const GOT_MYSTERYDANCER:int = 2;
		
		public var m_id:int;
		public var m_name:String;
		public var m_worktime:int;
		public var m_outputtype:int;
		public var m_outputvalue:int;
		public var m_icon:String;
		public var m_model:String;
		public function DancerBase() 
		{
			
		}
		public function parse(xml:XML):void
		{			
			m_id = UtilXML.attributeIntValue(xml, "id");
			m_name = UtilXML.attributeValue(xml, "name");
			m_worktime = UtilXML.attributeIntValue(xml, "worktime");
			m_outputtype = UtilXML.attributeIntValue(xml, "outputtype");
			m_outputvalue = UtilXML.attributeIntValue(xml, "outputvalue");
			m_icon = UtilXML.attributeValue(xml, "icon");
			m_model = UtilXML.attributeValue(xml, "model");
		}
		public function get type():int
		{
			var ret:int;
			if (this is NormalDancer)
			{
				ret = GOT_NARMALDANCER;
			}
			else if (this is MysteryDancer)
			{
				ret = GOT_MYSTERYDANCER;
			}
			else
			{				
			}
			return ret;
		}
		
		public function get isNormal():Boolean
		{
			return (this is NormalDancer);
		}
		
	}

}