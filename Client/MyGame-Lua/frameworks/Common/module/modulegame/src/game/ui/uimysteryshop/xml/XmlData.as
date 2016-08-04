package game.ui.uimysteryshop.xml
{
	import flash.utils.Dictionary;
	import game.ui.uimysteryshop.CommodityBase;
	/**
	 * @brief xml 数据
	 */
	public class XmlData 
	{
		public var m_dicTablabel:Dictionary;	//[level, YizheTabLabel]的集合	
		
		public function getdate(lvl:uint, id:uint):CommodityBase
		{
			if (m_dicTablabel[lvl])
			{
				return m_dicTablabel[lvl].getdate(id);
			}
			
			return null;
		}
		
		public function getDataByLvlID(lvlid:uint):CommodityBase
		{
			var lvl:uint = lvlid / 10000;
			var id:uint = lvlid/10%1000;
			return getdate(lvl, id);
		}
	}
}