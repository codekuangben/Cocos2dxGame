package game.netmsg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	/**
	 * ...
	 * @author ...
	 */
	public class updateUserMoveSpeedUserCmd extends stSceneUserCmd 
	{
		public var tempid:uint;
		public var m_moveSpeed:uint;
		public function updateUserMoveSpeedUserCmd() 
		{
			super();
			byParam = SceneUserParam.UPDATE_USER_MOVE_SPEED_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			tempid = byte.readUnsignedInt();
			m_moveSpeed = byte.readUnsignedByte();
		}
		
	}

}

//更新玩家移动速度
   /* const BYTE UPDATE_USER_MOVE_SPEED_USERCMD_PARA = 57;
    struct updateUserMoveSpeedUserCmd : public stSceneUserCmd 
    {    
        updateUserMoveSpeedUserCmd()
        {    
            byParam = UPDATE_USER_MOVE_SPEED_USERCMD_PARA;
            tempid = 0; 
            speed = 0; 
        }    
        DWORD tempid;
        BYTE speed;
    };   
*/