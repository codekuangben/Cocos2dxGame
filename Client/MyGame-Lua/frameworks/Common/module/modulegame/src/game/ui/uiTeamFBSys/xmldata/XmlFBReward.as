package game.ui.uiTeamFBSys.xmldata
{
	import modulecommon.scene.prop.object.ZObject;

	/**
	 * @brief 副本奖励
	 * */
	public class XmlFBReward
	{
		public var m_id:uint;
		public var m_num:uint;
		public var m_obj:ZObject;	// 对应的道具

		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_num = parseInt(xml.@num);
			
			m_obj = ZObject.createClientObject(m_id, m_num);
		}
	}
}