package modulecommon.scene.herorally 
{
	/**
	 * ...
	 * @author 
	 */
	import com.util.UtilXML;
	public class FieldTimeParam 
	{
		public var m_id:uint;
		public var m_startTime:Number;//开始时间
		public var m_endTime:Number;//结束时间
		public var m_timearea:String//起止时间
		public var m_pipeiTime:String//匹配时间
		public var m_fightTime:Array;//比赛三个时刻 {(第一局的战斗时刻)(第二局)(三)}
		public function FieldTimeParam() 
		{
			m_startTime = 0;
			m_endTime = 0;
			m_fightTime = new Array();
		}
		public function parse(xml:XML):void
		{	
			m_id = parseInt(xml.@id);
			m_timearea = UtilXML.attributeValue(xml, "timearea");
			var setimelist:Array = m_timearea.split("-");
			var onetime:Array = (setimelist[0] as String).split(":");
			m_pipeiTime = setimelist[0] + "-" + onetime[0] + ":" + (parseInt(onetime[1]) + 30);
			m_startTime = parseInt(onetime[0]) * 3600 + parseInt(onetime[1]) * 60;
			onetime = (setimelist[1] as String).split(":");
			m_endTime = parseInt(onetime[0]) * 3600 + parseInt(onetime[1]) * 60;
			var time:String = UtilXML.attributeValue(xml, "first");
			m_fightTime.push(time);
			time = UtilXML.attributeValue(xml, "secend");
			m_fightTime.push(time);
			time = UtilXML.attributeValue(xml, "last");
			m_fightTime.push(time);
			
		}
	}

}