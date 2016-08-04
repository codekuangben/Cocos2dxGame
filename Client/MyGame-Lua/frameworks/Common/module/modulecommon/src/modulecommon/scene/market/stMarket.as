package modulecommon.scene.market 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	public class stMarket 
	{
		public static const MONEYTYPE_yuanbao:int = 0;		//元宝
		public static const MONEYTYPE_rongyu:int = 1;		//荣誉勋章
		public static const MONEYTYPE_corpsGongxian:int = 2;		//军团贡献
		
		public static const TYPE_timelimit:int = 0;	//限时区域
		public static const TYPE_remai:int = 1;		//热卖
		public static const TYPE_baoshi:int = 2;	//宝石
		public static const TYPE_daoju:int = 3;		//道具
		public static const TYPE_Rongyu:int = 4;		//荣誉商场
		
		public static const TYPE_corps:int = 20;		//军团商城
		
		public var m_moneyType:int;
		public var m_type:int;
		public var m_name:String;
		public var m_list:Array;
		public function stMarket(type:int, moneyType:int) 
		{
			m_type = type;
			m_moneyType = moneyType;
			switch(m_type)
			{
				case TYPE_remai:int: m_name = "热卖"; break;
				case TYPE_baoshi:int: m_name = "宝石"; break;
				case TYPE_daoju:int: m_name = "道具"; break;	
				case TYPE_Rongyu:int: m_name = "荣誉商场"; break;
			}
		}
		
		//查询相应道具的商品对象
		public function getPrice(id:uint):stMarketBaseObj
		{
			var marketItem:stMarketBaseObj;
			for each(marketItem in m_list)
			{
				if (marketItem.id == id)
				{
					return marketItem;
				}
			}
			return null;
		}
		
		public function setList(list:Array):void
		{
			m_list = list;
			var base:stMarketBaseObj;
			for each(base in m_list)
			{
				base.m_market = this;
			}
		}
		
		public function  deserialize(byte:ByteArray):void
		{
			var size:int = byte.readUnsignedShort();
			var marketItem:stMarketBaseObj;
						
			var itemClass:Class;
			if (m_type == TYPE_timelimit)
			{
				itemClass = stMarketOnSaleObj;
			}
			else
			{
				itemClass = stMarketBaseObj;
			}
			m_list = new Array();
			var i:int;
			for (i = 0; i < size; i++)
			{
				marketItem = new itemClass();
				marketItem.m_market = this;
				marketItem.deserialize(byte);
				if (TYPE_timelimit != m_type)
				{
					marketItem.discoutprice = marketItem.price;
				}
				m_list.push(marketItem);
			}
		}
	}

}