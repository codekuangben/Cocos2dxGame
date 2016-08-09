package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.market.MarketsData;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetGoldMallDataCmd extends stShoppingCmd 
	{		
		public function stRetGoldMallDataCmd() 
		{
			byParam = PARA_RET_GOLDMALL_DATA_CMD;				
		}
		public function deserializeYuanbao(marketData:MarketsData, byte:ByteArray):void 
		{
			super.deserialize(byte);
			marketData.deserializeYuanbaoMarket(byte);
		}
		
	}

}

//返回元宝商城数据
	/*const BYTE PARA_RET_GOLDMALL_DATA_CMD = 2;
	struct stRetGoldMallDataCmd : public stShoppingCmd
	{
		stRetGoldMallDataCmd()
		{
			byParam = PARA_RET_GOLDMALL_DATA_CMD;
		}
		WORD hotsize;
		stMarketBaseObj hotobjs[0];
		WORD gemsize;
		stMarketBaseObj gemobjs[0];
		WORD normalsize;
		stMarketBaseObj normalobjs[0];
		WORD timelimitsize;
		stMarketOnSaleObj onsaleobjs[0];
		WORD honorobjsize;
        stMarketBaseObj honorobjs[0];
        WORD corpsobjsize;
        stMarketBaseObj corpsobjs[0];

	};*/