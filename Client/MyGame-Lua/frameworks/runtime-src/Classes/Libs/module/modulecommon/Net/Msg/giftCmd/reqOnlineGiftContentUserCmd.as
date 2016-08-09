package modulecommon.net.msg.giftCmd
{
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author 
	 */
	public class reqOnlineGiftContentUserCmd extends stGiftCmd
	{
		public function reqOnlineGiftContentUserCmd() 
		{
			byParam = REQ_ONLINE_GIFT_CONTENT_USERCMD;
		}
	}
}

//const BYTE REQ_ONLINE_GIFT_CONTENT_USERCMD = 3;
//struct reqOnlineGiftContentUserCmd : public stGiftCmd
//{
	//reqOnlineGiftContentUserCmd()
	//{
		//byParam = REQ_ONLINE_GIFT_CONTENT_USERCMD;
	//}
//};