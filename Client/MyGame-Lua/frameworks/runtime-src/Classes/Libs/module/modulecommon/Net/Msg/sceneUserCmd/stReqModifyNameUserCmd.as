package modulecommon.net.msg.sceneUserCmd 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	/**
	 * ...
	 * @author 
	 */
	public class stReqModifyNameUserCmd extends stSceneUserCmd
	{
		
		public function stReqModifyNameUserCmd() 
		{
			byParam = SceneUserParam.REQ_MODIFYNAME_USERCMD_PARA;
		}
		
	}

}

/*
////请求改名字
    const BYTE REQ_MODIFYNAME_USERCMD_PARA = 26; 
    struct stReqModifyNameUserCmd : public stSceneUserCmd
    {   
        stReqModifyNameUserCmd()
        {   
            byParam = REQ_MODIFYNAME_USERCMD_PARA;
        }   
    };  
*/