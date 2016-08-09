package modulecommon.net.msg.shoppingCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.market.MarketsData;
	public class stRetAllMarketObjInfoCmd  extends stShoppingCmd 
	{
		
		public function stRetAllMarketObjInfoCmd() 
		{
			byParam = PARA_RET_ALL_MARKET_OBJINFO_CMD;		
		}
		public function deserializeYuanbao(marketData:MarketsData, byte:ByteArray):void 
		{
			super.deserialize(byte);
			marketData.deserializeYuanbaoMarket(byte);
		}
	}

}

//返回商城所有物品信息
    /*const BYTE PARA_RET_ALL_MARKET_OBJINFO_CMD = 12;
    struct stRetAllMarketObjInfoCmd : public stShoppingCmd
    {
        stRetAllMarketObjInfoCmd()
        {
            byParam = PARA_RET_ALL_MARKET_OBJINFO_CMD;
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
    };
*/