package modulecommon.scene.benefithall.LimitBigSendAct 
{
	/**
	 * ...
	 * @author 
	 */
	public class ItemOfDay 
	{
		public var m_begin:uint;//开始日期
		public var m_end:uint//活动结束日期 领取日期延后一天
		public var m_LimitBigSendActItemList:Array;//这一页的物品
		public function ItemOfDay() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_begin = parseInt(xml.@begin);
			m_end = parseInt(xml.@end);
			m_LimitBigSendActItemList = new Array();
			var tabXml:XML;
			for each (tabXml in xml.elements("actitem"))
			{
				var item:LimitBigSendActItem = new LimitBigSendActItem();
				item.parse(tabXml);
				m_LimitBigSendActItemList.push(item);
			}
		}
		
	}

}