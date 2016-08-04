package modulecommon.net.msg.giftCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stFirstChargeBoxInfoCmd extends stGiftCmd
	{
		public var m_state:uint;
		public var m_giftList:Array;
		
		public function stFirstChargeBoxInfoCmd() 
		{
			byParam = PARA_FIRSTCHARGE_GIFTBOX_INFO_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_state = byte.readUnsignedByte();
			
			var size:int = byte.readUnsignedShort();
			var giftitem:GiftItem;
			var i:int;
			m_giftList = new Array();
			for (i = 0; i < size; i++)
			{
				giftitem = new GiftItem();
				giftitem.deserialize(byte);
				
				m_giftList.push(giftitem);
			}
		}
	}

}

/*
//首充礼包信息
    const BYTE PARA_FIRSTCHARGE_GIFTBOX_INFO_CMD = 15; 
    struct stFirstChargeBoxInfoCmd : public stGiftCmd
    {   
        stFirstChargeBoxInfoCmd()
        {   
            byParam = PARA_FIRSTCHARGE_GIFTBOX_INFO_CMD;
            state = 0;
            size = 0;
        }   
        BYTE state; //按位 第一位:是否充值 第二位:是否领取礼包  
        WORD size;
        GiftItem objlist[0];
        WORD getSize()
        {   
            return (sizeof(*this) + size*sizeof(GiftItem));
        }   
    };  
*/