package game.netmsg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyOnlineGiftUserCmd extends stGiftCmd
	{
		public var id:uint = 0;
		public var time:uint = 0;
		
		public function stNotifyOnlineGiftUserCmd() 
		{
			byParam = NOTIFY_ONLINE_GIFT_USERCMD;	
		}
	
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
			time = byte.readUnsignedInt();
		}
	}
}

//在线礼包 s->c
//const BYTE NOTIFY_ONLINE_GIFT_USERCMD = 1;
//struct stNotifyOnlineGiftUserCmd : public stGiftCmd
//{
	//stNotifyOnlineGiftUserCmd()
	//{
		//byParam = NOTIFY_ONLINE_GIFT_USERCMD;
		//id = time = 0;
	//}
	//DWORD id;
	//DWORD time;
//};