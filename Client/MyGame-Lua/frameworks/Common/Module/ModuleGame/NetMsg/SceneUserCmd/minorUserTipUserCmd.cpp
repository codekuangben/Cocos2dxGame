package game.netmsg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class minorUserTipUserCmd extends stSceneUserCmd
	{
		public var m_hour:uint;
		
		public function minorUserTipUserCmd() 
		{
			byParam = SceneUserParam.MINOR_USER_TIP_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_hour = byte.readUnsignedByte();
		}
		
	}

}

/*
//未成年人提示框
    const BYTE MINOR_USER_TIP_USERCMD = 53;
    struct minorUserTipUserCmd : public stSceneUserCmd
    {    
        minorUserTipUserCmd()
        {    
            byParam = MINOR_USER_TIP_USERCMD;
            hour = 0; 
        }    
        BYTE hour; //在线小时数
    }; 
*/