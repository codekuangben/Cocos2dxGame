package modulecommon.net.msg.shoppingCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stShoppingCmd extends stNullUserCmd 
	{
		public static const PARA_REQ_SHOPPINGMALL_DATA_CMD:uint = 1;
		public static const PARA_RET_GOLDMALL_DATA_CMD:uint = 2;
		public static const PARA_NOTIFY_MARKET_DATA_UPDATE_CMD:uint = 3;
		public static const PARA_BUY_MARKETOBJ_CMD:uint = 4;	
		public static const PARA_REQ_OBJ_BUYLIMITNUM_CMD:uint = 5;
		public static const PARA_RET_OBJ_BUYLIMITNUM_CMD:uint = 6;	
		public static const PARA_REQ_VIEW_MARKET_GIFTBOX_CMD:uint = 7;
		public static const PARA_RET_MARKET_GIFTBOX_CONTENT_CMD:uint = 8;	
		public static const PARA_RET_HONORMALL_DATA_CMD:uint = 9;	
		public static const PARA_REQ_CORPSMALL_OBJLIST_CMD:uint = 10;	
		public static const PARA_RET_CORPSMALL_OBJLIST_CMD:uint = 11;	
		public static const PARA_RET_ALL_MARKET_OBJINFO_CMD:uint = 12;
		public function stShoppingCmd() 
		{
			byCmd = SHOPPING_USERCMD;  // 20
			
		}
		
	}

}