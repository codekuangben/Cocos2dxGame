package modulecommon.scene.benefithall.dailyactivities 
{
	/**
	 * ...
	 * @author ...
	 * 奖励道具
	 */
	public class ItemProps 
	{
		public var m_id:uint;		//道具id
		public var m_num:uint;		//道具数量
		public var m_upgrade:uint;	//道具品质(颜色),没有默认为0
		
		public function ItemProps() 
		{
			m_id = 0;
			m_num = 0;
			m_upgrade = 0;
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_num = parseInt(xml.@num);
			m_upgrade = parseInt(xml.@upgrade);
		}
	}

}