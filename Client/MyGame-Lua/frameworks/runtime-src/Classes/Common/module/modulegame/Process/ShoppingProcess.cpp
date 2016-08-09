package game.process 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.shoppingCmd.stShoppingCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShoppingProcess extends ProcessBase 
	{
		
		public function ShoppingProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stShoppingCmd.PARA_RET_ALL_MARKET_OBJINFO_CMD] = m_gkContext.m_marketMgr.processst_stRetAllMarketObjInfoCmd;
			dicFun[stShoppingCmd.PARA_NOTIFY_MARKET_DATA_UPDATE_CMD] = m_gkContext.m_marketMgr.processstNotifyMarketDataUpdateCmd;
			dicFun[stShoppingCmd.PARA_RET_OBJ_BUYLIMITNUM_CMD] = m_gkContext.m_marketMgr.processsstRetObjBuyLimitNumCmd;
			dicFun[stShoppingCmd.PARA_RET_MARKET_GIFTBOX_CONTENT_CMD] = m_gkContext.m_marketMgr.processstRetMarketGiftBoxContentCmd;
			//dicFun[stShoppingCmd.PARA_RET_HONORMALL_DATA_CMD] = m_gkContext.m_marketMgr.processs_stRetHonorMallDataCmd;
			//dicFun[stShoppingCmd.PARA_RET_CORPSMALL_OBJLIST_CMD] = m_gkContext.m_corpsMarketMgr.process_stRetCorpsMallObjListCmd;
		}
	}

}