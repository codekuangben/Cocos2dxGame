package modulecommon.scene.wu 
{
	/**
	 * ...
	 * @author ...
	 * 培养所需道具: 元气丹
	 */
	public class YuanqiDan 
	{
		public var m_id:uint;		//道具id
		public var m_yuanbao:uint;	//所需元宝数
		public var m_levellimit:uint;	//等级限制
		
		public function YuanqiDan() 
		{
			
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_yuanbao = parseInt(xml.@yuanbao);
			m_levellimit = parseInt(xml.@levellimit);
		}
		
	}

}