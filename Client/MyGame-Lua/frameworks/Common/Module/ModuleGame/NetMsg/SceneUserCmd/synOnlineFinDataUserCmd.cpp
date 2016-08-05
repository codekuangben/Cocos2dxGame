package game.netmsg.sceneUserCmd 
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class synOnlineFinDataUserCmd extends stSceneUserCmd
	{
		
		public function synOnlineFinDataUserCmd() 
		{
			byParam = SceneUserParam.SYN_ONLINE_FIN_DATA_USERCMD;
		}
		
	}

}
/*
const BYTE SYN_ONLINE_FIN_DATA_USERCMD = 54;
    struct synOnlineFinDataUserCmd : public stSceneUserCmd
    {    
        synOnlineFinDataUserCmd()
        {    
            byParam = SYN_ONLINE_FIN_DATA_USERCMD;
        }    
    };
*/