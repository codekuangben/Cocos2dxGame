package modulecommon.scene.benefithall.LimitBigSendAct 
{
	/**
	 * ...
	 * @author 
	 */
	public class LimitBigSendActItem 
	{
		public var m_id:uint;//条目id
		public var m_index:uint//排序用index
		public var m_condition:uint;//进度总次数
		public var m_rewardtimes:uint;//可兑换总次数
		public var m_name:String;//条目名称
		public var m_rule:String;//规则
		public var m_objList:Array;//奖励物品属性
		
		public function LimitBigSendActItem() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_index = parseInt(xml.@index);
			m_condition = parseInt(xml.@condition);
			m_rewardtimes = parseInt(xml.@rewardtimes);
			m_name = xml.@name;
			m_rule = xml.child("rule").toString();
			var Xml:XML;
			m_objList = new Array();
			for each(Xml in xml.child("obj"))
			{
				var item:Object = new Object();
				item.m_id = parseInt(Xml.@id);
				item.m_num = parseInt(Xml.@num);
				item.m_upgrade = parseInt(Xml.@upgrade);
				m_objList.push(item);
			}
		}
		
	}

}