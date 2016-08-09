package modulecommon.scene.benefithall.rebate 
{
	/**
	 * ...
	 * @author 
	 */
	public class RechargeRebateObj 
	{
		public var m_id:uint//物品id
		public var m_type:uint//奖励类型：1.道具类 2.武将类
		public var m_upgrade:uint//对于道具类:品质(颜色) 对于武将类:转生次数
		public var m_num:uint//数量
		public var m_anicolor:uint//转动特效颜色
		public function RechargeRebateObj() 
		{
			
		}
		public function parse(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_type = parseInt(xml.@type);
			m_upgrade = parseInt(xml.@upgrade);
			m_num = parseInt(xml.@num);
			m_anicolor = parseInt(xml.@anicolor);
		}
	}

}