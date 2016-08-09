package modulecommon.scene.benefithall.rebate 
{
	/**
	 * ...
	 * @author 
	 */
	public class RechargeRebateItem 
	{
		public var m_id:int//条目id
		public var m_numYB:uint//元宝数
		public var m_rebateObjList:Array//物品数组 RechargeRebateItem
		public function RechargeRebateItem() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_numYB = parseInt(xml.@yuanbaonum);
			var Xml:XML;
			m_rebateObjList = new Array();
			for each(Xml in xml.child("obj"))
			{
				var item:RechargeRebateObj = new RechargeRebateObj();
				item.parse(Xml);
				m_rebateObjList.push(item);
			}
		}
	}

}