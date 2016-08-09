package modulecommon.net.msg.eliteBarrierCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stLeftTiaoZhanOnlineCmd extends stEliteBarrierCmd
	{
		public var lefttimes:uint;
		
		public function stLeftTiaoZhanOnlineCmd() 
		{
			byParam = PARA_LEFT_TIAOZHAN_ONLINE_CMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			lefttimes = byte.readUnsignedShort();
		}
	}

}

/*
//上线发送剩余挑战次数
    const BYTE PARA_LEFT_TIAOZHAN_ONLINE_CMD = 12; 
    struct stLeftTiaoZhanOnlineCmd : public stEliteBarrierCmd
    {   
        stLeftTiaoZhanOnlineCmd()
        {   
            byParam = PARA_LEFT_TIAOZHAN_ONLINE_CMD;
            lefttimes = 0;
        }   
        WORD lefttimes;
    };  
*/