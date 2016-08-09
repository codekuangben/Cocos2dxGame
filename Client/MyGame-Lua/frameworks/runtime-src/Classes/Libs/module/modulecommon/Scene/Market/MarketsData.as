package modulecommon.scene.market
{
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MarketsData
	{
		public var m_dic:Dictionary;
		
		public function MarketsData()
		{
			m_dic = new Dictionary();
		}
		
		public function clearAllData():void
		{
			m_dic = new Dictionary();
		}
		
		public function deserializeYuanbaoMarket(byte:ByteArray):void
		{
			var market:stMarket;
			market = new stMarket(stMarket.TYPE_remai, stMarket.MONEYTYPE_yuanbao);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
			
			market = new stMarket(stMarket.TYPE_baoshi, stMarket.MONEYTYPE_yuanbao);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
			
			market = new stMarket(stMarket.TYPE_daoju, stMarket.MONEYTYPE_yuanbao);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
			
			market = new stMarket(stMarket.TYPE_timelimit, stMarket.MONEYTYPE_yuanbao);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
			
			market = new stMarket(stMarket.TYPE_Rongyu, stMarket.MONEYTYPE_rongyu);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
			
			market = new stMarket(stMarket.TYPE_corps, stMarket.MONEYTYPE_corpsGongxian);
			market.deserialize(byte);
			m_dic[market.m_type] = market;
		}
		
		public function add(type:int, market:stMarket):void
		{
			m_dic[type] = market;
		}
		
		public function getPrice(id:uint):stMarketBaseObj
		{
			var market:stMarket;
			var marketObj:stMarketBaseObj;
			for each (market in m_dic)
			{
				if (market.m_moneyType == stMarket.MONEYTYPE_yuanbao)
				{
					marketObj = market.getPrice(id);
					if (marketObj)
					{
						return marketObj;
					}
				}
			}
			return null;
		}
		
		public function hasMarket(type:int):Boolean
		{
			return m_dic[type] != undefined;
		}
		
		public function getMarketByMoneyTypeAndID(type:int, id:uint):stMarketBaseObj
		{
			var market:stMarket;
			var ret:stMarketBaseObj;
			for each(market in m_dic)
			{
				if (market.m_moneyType == type)
				{
					ret = market.getPrice(id);
					if (ret)
					{
						return ret;
					}
				}
			}
			return null;
		}
	}

}