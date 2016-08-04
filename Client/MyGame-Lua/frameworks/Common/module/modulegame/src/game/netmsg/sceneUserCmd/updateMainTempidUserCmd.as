package game.netmsg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class updateMainTempidUserCmd extends stSceneUserCmd 
	{
		public var tempid:uint;
		public function updateMainTempidUserCmd() 
		{
			super();
			byParam = SceneUserParam.UPDATE_MAIN_TEMPID_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			tempid = byte.readUnsignedInt();
		}
	}

}

//更新主角tempid;
   /* const BYTE UPDATE_MAIN_TEMPID_USERCMD_PARA = 56;
    struct updateMainTempidUserCmd : public stSceneUserCmd 
    {    
        updateMainTempidUserCmd()
        {    
            byParam = UPDATE_MAIN_TEMPID_USERCMD_PARA;
            tempid  = 0; 
        }    
        DWORD tempid ;
    }; */