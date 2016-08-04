package game.ui.uilqwj.msg 
{
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * @author ...
	 */
	public class stReqQuickCoolOnlineGiftCmd extends stGiftCmd
	{
		public function stReqQuickCoolOnlineGiftCmd()
		{
			byParam = stGiftCmd.REQ_QUICK_COOL_ONLINE_GIFT_CMD;
		}
	}
}

//请求快速冷却在线礼包
//const BYTE REQ_QUICK_COOL_ONLINE_GIFT_CMD = 29; 
//struct stReqQuickCoolOnlineGiftCmd : public stGiftCmd
//{   
	//stReqQuickCoolOnlineGiftCmd()
	//{   
		//byParam = REQ_QUICK_COOL_ONLINE_GIFT_CMD;
	//}   
//};