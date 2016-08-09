package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class notifyCorpsFirePosUserCmd extends stCorpsCmd
	{
		public var m_firePosX:int;
		public var m_firePosY:int;
		
		public function notifyCorpsFirePosUserCmd() 
		{
			byParam = NOTIFY_CORPS_FIRE_POS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_firePosX = byte.readUnsignedShort();
			m_firePosY = byte.readUnsignedShort();
		}
	}

}

/*
//通知军团烤火坐标
    const BYTE NOTIFY_CORPS_FIRE_POS_USERCMD = 64;
    struct notifyCorpsFirePosUserCmd : public stCorpsCmd
    {    
        notifyCorpsFirePosUserCmd()
        {    
            byParam = NOTIFY_CORPS_FIRE_POS_USERCMD;
            x = y = 0; 
        }    
        WORD x;
        WORD y;
    };  
*/