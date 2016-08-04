package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqViewMarketGiftBoxCmd extends stShoppingCmd 
	{
		public var boxid:uint;
		public function stReqViewMarketGiftBoxCmd() 
		{
			byParam = PARA_REQ_VIEW_MARKET_GIFTBOX_CMD;
			
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(boxid);
		}
	}

}

//请求商城礼包内容
    /*const BYTE PARA_REQ_VIEW_MARKET_GIFTBOX_CMD = 7;
    struct stReqViewMarketGiftBoxCmd : public stShoppingCmd
    {
        stReqViewMarketGiftBoxCmd()
        {
            byParam = PARA_REQ_VIEW_MARKET_GIFTBOX_CMD;
            boxid = 0;
        }
        DWORD boxid;    //礼包id
    };*/