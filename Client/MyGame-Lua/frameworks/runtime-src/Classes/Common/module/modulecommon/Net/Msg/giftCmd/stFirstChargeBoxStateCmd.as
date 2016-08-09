package modulecommon.net.msg.giftCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stFirstChargeBoxStateCmd extends stGiftCmd
	{
		public var m_state:uint;
		
		public function stFirstChargeBoxStateCmd() 
		{
			byParam = PARA_FIRSTCHARGE_BOX_STATE_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_state = byte.readUnsignedByte();
		}
	}

}
/*
//首充礼包状态
    const BYTE PARA_FIRSTCHARGE_BOX_STATE_CMD = 16; 
    struct stFirstChargeBoxStateCmd : public stGiftCmd
    {
        stFirstChargeBoxInfoCmd()
        {
            byParam = PARA_FIRSTCHARGE_BOX_STATE_CMD;
            state = 0;
        }
        BYTE state;
    };

*/