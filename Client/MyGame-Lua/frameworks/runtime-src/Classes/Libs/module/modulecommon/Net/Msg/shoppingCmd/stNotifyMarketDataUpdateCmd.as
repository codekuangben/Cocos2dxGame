package modulecommon.net.msg.shoppingCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyMarketDataUpdateCmd extends stShoppingCmd 
	{
		
		public function stNotifyMarketDataUpdateCmd() 
		{
			byParam = PARA_NOTIFY_MARKET_DATA_UPDATE_CMD;
			
		}
		
	}

}

//通知client商城数据更新
	/*const BYTE PARA_NOTIFY_MARKET_DATA_UPDATE_CMD = 3;
	struct stNotifyMarketDataUpdateCmd : public stShoppingCmd
	{
		stNotifyMarketDataUpdateCmd()
		{
			byParam = PARA_NOTIFY_MARKET_DATA_UPDATE_CMD;
		}
	};*/