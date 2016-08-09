package modulecommon.net.msg.giftCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyActLiBaoStateCmd extends stGiftCmd
	{
		public var m_state:uint;
		
		public function stNotifyActLiBaoStateCmd() 
		{
			byParam = PARA_NOTIFY_ACTLIBAO_STATE_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_state = byte.readUnsignedByte();
		}
	}

}
/*
//通知活动礼包活动状态
    const BYTE PARA_NOTIFY_ACTLIBAO_STATE_CMD = 18; 
    struct stNotifyActLiBaoStateCmd : public stGiftCmd
    {   
        stNotifyActLiBaoStateCmd()
        {   
            byParam = PARA_NOTIFY_ACTLIBAO_STATE_CMD;
            state = 0;
        }   
        BYTE state;     //1-开始 0-结束
    }; 
*/