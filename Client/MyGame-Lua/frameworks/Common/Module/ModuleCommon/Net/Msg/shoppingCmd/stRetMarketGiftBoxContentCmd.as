package modulecommon.net.msg.shoppingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.ObjectDataVirtual;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetMarketGiftBoxContentCmd extends stShoppingCmd 
	{
		public var m_objID:uint;
		public var m_list:Array;
		public function stRetMarketGiftBoxContentCmd() 
		{
			byParam = PARA_RET_MARKET_GIFTBOX_CONTENT_CMD;			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_objID = byte.readUnsignedInt();
			m_list = ObjectDataVirtual.s_readArray(byte);
		}
		
	}

}

//返回商城礼包内容
   /* const BYTE PARA_RET_MARKET_GIFTBOX_CONTENT_CMD = 8;
    struct stRetMarketGiftBoxContentCmd : public stShoppingCmd
    {
        stRetMarketGiftBoxContentCmd()
        {
            byParam = PARA_RET_MARKET_GIFTBOX_CONTENT_CMD;
            boxid = 0;
            num = 0;
        }
        DWORD boxid;
        WORD num;
        stMarketGiftItem list[0];
        WORD getSize()
        {
            return (sizeof(*this) + num*sizeof(stMarketGiftItem));
        }
    };*/