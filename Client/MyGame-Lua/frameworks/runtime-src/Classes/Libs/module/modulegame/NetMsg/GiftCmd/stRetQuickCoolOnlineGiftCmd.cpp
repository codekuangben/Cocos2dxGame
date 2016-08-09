package game.netmsg.giftCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.giftCmd.stGiftCmd;
	/**
	 * @author ...
	 */
	public class stRetQuickCoolOnlineGiftCmd extends stGiftCmd
	{
		public var ret:uint;

		public function stRetQuickCoolOnlineGiftCmd() 
		{
			byParam = stGiftCmd.RET_QUICK_COOL_ONLINE_GIFT_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			ret = byte.readUnsignedByte();
		}
	}
}

//返回快速冷却在线礼包
//const BYTE RET_QUICK_COOL_ONLINE_GIFT_CMD = 30; 
//struct stRetQuickCoolOnlineGiftCmd : public stGiftCmd
//{   
	//stRetQuickCoolOnlineGiftCmd()
	//{   
		//byParam = RET_QUICK_COOL_ONLINE_GIFT_CMD;
		//ret = 0;
	//}   
	//BYTE ret; //0:成功 1：失败
//};