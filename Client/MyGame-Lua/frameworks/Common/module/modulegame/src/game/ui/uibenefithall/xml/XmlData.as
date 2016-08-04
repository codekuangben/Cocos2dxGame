package game.ui.uibenefithall.xml
{
	/**
	 * @brief xml 数据
	 */
	public class XmlData 
	{
		public var m_activeLst:Vector.<XmlJLZHActiveIteam>;
		
		public function XmlData() 
		{
			m_activeLst = new Vector.<XmlJLZHActiveIteam>();
		}
		
		public function findActiveItemByID(id:uint):XmlJLZHActiveIteam
		{
			for each(var item:XmlJLZHActiveIteam in m_activeLst)
			{
				if (item.m_id == id)
				{
					return item;
				}
			}
			
			return null;
		}
	}
}