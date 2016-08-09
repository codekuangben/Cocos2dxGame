package modulecommon.net.msg.giftCmd
{
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stGiftCmd extends stNullUserCmd
	{
		public static const NOTIFY_ONLINE_GIFT_USERCMD:uint = 1;
		public static const REQ_ONLINE_GIFT_CONTENT_USERCMD:uint = 3;
		public static const RET_ONLINE_GIFT_CONTENT_USERCMD:uint = 4;
		public static const REQ_GET_ONLINE_GIFT_USERCMD:uint = 5;
		public static const NOTIFY_ONLINE_GIFT_END_USERCMD:uint = 6;
		public static const RET_LEVEL_GIFT_CONTENT_USERCMD :uint = 8;
		public static const REQ_GET_LEVEL_GIFT_USERCMD:uint = 9;
		public static const RET_GET_GIFT_SUCCESS_USERCMD:uint = 10;
		public static const SYN_SEND_GIFT_OBJS_END_USERCMD:uint = 11;
		public static const REQ_USE_RANDOM_GIFT_USERCMD:uint = 12;
		public static const RET_RANDOM_GIFT_CONTENT_USERCMD:uint = 13;
		public static const REQ_GET_RANDOM_GIFT_USERCMD:uint = 14;
		public static const PARA_FIRSTCHARGE_GIFTBOX_INFO_CMD:uint = 15;
		public static const PARA_FIRSTCHARGE_BOX_STATE_CMD:uint = 16;
		public static const PARA_REQ_GET_FIRSTCHARGE_BOX_CMD:uint = 17;
		public static const PARA_NOTIFY_ACTLIBAO_STATE_CMD:uint = 18;
		public static const PARA_REQ_ACTLIBAO_CONTENT_CMD:uint = 19;
		public static const PARA_RET_ACTLIBAO_CONTENT_CMD:uint = 20;
		public static const PARA_REQ_GET_ACTLIBAO_CMD:uint = 21;
		public static const PARA_ALREADY_PURCHASE_YZLB_OBJLIST_CMD:uint = 22;
		public static const PARA_REQ_BUY_YZLB_OBJ_CMD:uint = 23;
		public static const PARA_NOTIFY_REFRESH_SECRET_STORE_OBJLIST_CMD:uint = 24;
		public static const PARA_REQ_SECRET_STORE_OBJLIST_CMD:uint = 25;
		public static const PARA_RET_SECRET_STORE_OBJLIST_CMD:uint = 26;
		public static const PARA_BUY_SECRET_STORE_OBJ_CMD:uint = 27;
		public static const PARA_REQ_REFRESH_SECRET_STORE_OBJLIST_CMD:uint = 28;
		public static const REQ_QUICK_COOL_ONLINE_GIFT_CMD:uint = 29;
		public static const RET_QUICK_COOL_ONLINE_GIFT_CMD:uint = 30;

		public function stGiftCmd() 
		{
			byCmd = GIFT_USERCMD;
		}
	}
}

//struct stGiftCmd : public stNullUserCmd
//{
//	stGiftCmd()
//	{
//		byCmd = GIFT_USERCMD; //17
//	}
//};