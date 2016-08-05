package modulecommon.scene.market
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	
	public class stMarketBaseObj
	{
		public static const TAG_None:int = 0; //无标签
		public static const TAG_Remai:int = 1; //热卖
		public static const TAG_Qianggou:int = 2; //抢购
		public var m_market:stMarket;
		public var id:uint;
		public var state:uint;
		public var price:uint;
		public var discoutprice:uint;
		public var buylimit:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			state = byte.readUnsignedByte();
			price = byte.readUnsignedInt();
			discoutprice = byte.readUnsignedInt();
			buylimit = byte.readUnsignedShort();
		}
		
		public function get tag():int
		{
			var ret:int;
			switch (state)
			{
				case 1: 
					ret = TAG_Remai;
					break;
				case 2: 
				case 4: 
					ret = TAG_Qianggou;
					break;
				default: 
					ret = TAG_None;
					break;
			}
			return ret;
		}
		
		public function computeMaxNumWidthBuyLimit(gk:GkContext):int
		{
			var maxBuy:int;
			var objBase:TObjectBaseItem = gk.m_dataTable.getItem(DataTable.TABLE_OBJECT, id) as TObjectBaseItem;
			if (m_market.m_moneyType == stMarket.MONEYTYPE_yuanbao)
			{
				
				if (buylimit > 0)
				{
					if (m_market.m_type == stMarket.TYPE_timelimit)
					{
						var numBuy:int = gk.m_marketMgr.queryNumObjBuy(id);
						maxBuy = buylimit - numBuy;
					}
				}
				else
				{
					maxBuy = objBase.m_uMaxNum;
				}
			}
			else if (m_market.m_moneyType == stMarket.MONEYTYPE_rongyu)
			{
				maxBuy = objBase.m_uMaxNum;
			}
			else if (m_market.m_moneyType == stMarket.MONEYTYPE_corpsGongxian)
			{
				if (buylimit > 0)
				{
					if (m_market.m_type == stMarket.TYPE_corps)
					{
						numBuy = gk.m_marketMgr.queryNumObjBuyInCorpsMarket(id);
						maxBuy = buylimit - numBuy;
					}
				}
				else
				{
					maxBuy = objBase.m_uMaxNum;
				}
			}
			return maxBuy;
		}
	
	}

}

//商城主区域物品数据
/*struct stMarketBaseObj
   {
   DWORD objid;	//道具id
   BYTE state;		//物品状态 (0:普通 1:热卖 2:特价 4:开服特卖 按位计算)
   DWORD price;	//原价
   DWORD discoutprice;	//折后价
   WORD buylimit;  //购买上限
   stMarketBaseObj()
   {
   objid = 0;
   state = 0;
   price = discoutprice = 0;
   }
 };*/