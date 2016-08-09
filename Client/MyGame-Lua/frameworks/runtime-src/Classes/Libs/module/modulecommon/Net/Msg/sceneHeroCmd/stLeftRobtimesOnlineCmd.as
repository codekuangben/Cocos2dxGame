package modulecommon.net.msg.sceneHeroCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stLeftRobtimesOnlineCmd extends stSceneHeroCmd
	{
		public var m_robtimes:uint;
		
		public function stLeftRobtimesOnlineCmd() 
		{
			byParam = PARA_LEFT_ROBTIMES_ONLINE_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_robtimes = byte.readUnsignedShort();
		}
	}

}

/*
 * //宝物抢夺剩余次数
	const BYTE PARA_LEFT_ROBTIMES_ONLINE_USERCMD = 32; 
    struct stLeftRobtimesOnlineCmd : public stSceneHeroCmd
    {   
        stLeftRobtimesOnlineCmd()
        {   
            byParam = PARA_LEFT_ROBTIMES_ONLINE_USERCMD;
            robtimes = 0;
        }   
        WORD robtimes;
    };  
*/