package modulecommon.net.msg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author 
	 */
	public class reqGetOnlineGiftUserCmd extends stGiftCmd
	{
		public var id:uint;
		
		public function reqGetOnlineGiftUserCmd() 
		{
			byParam = REQ_GET_ONLINE_GIFT_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(id);
		}
	}
}

//请求领奖在线礼包
//const BYTE REQ_GET_ONLINE_GIFT_USERCMD = 5;
//struct reqGetOnlineGiftUserCmd : public stGiftCmd
//{
	//reqGetOnlineGiftUserCmd()
	//{
		//byParam = REQ_GET_ONLINE_GIFT_USERCMD;
		//id = 0;
	//}
	//DWORD id;
//};