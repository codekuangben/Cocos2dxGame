package game.netmsg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class notifyOnlineGiftEndUserCmd extends stGiftCmd
	{
		public function notifyOnlineGiftEndUserCmd() 
		{
			byParam = NOTIFY_ONLINE_GIFT_END_USERCMD;
		}
	}
}

//通知客户端无后续礼包(了)
//const BYTE NOTIFY_ONLINE_GIFT_END_USERCMD = 6;
//struct notifyOnlineGiftEndUserCmd : public stGiftCmd
//{   
	//notifyOnlineGiftEndUserCmd()
	//{   
		//byParam = NOTIFY_ONLINE_GIFT_END_USERCMD;
	//}   
//};