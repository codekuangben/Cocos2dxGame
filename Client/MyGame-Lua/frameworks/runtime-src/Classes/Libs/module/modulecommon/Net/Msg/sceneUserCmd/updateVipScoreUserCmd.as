package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class updateVipScoreUserCmd extends stSceneUserCmd
	{
		public var m_vipscore:uint;
		public function updateVipScoreUserCmd() 
		{
			byParam = SceneUserParam.UPDATE_USER_VIP_SCORE_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_vipscore = byte.readUnsignedInt();
		}
	}

}

/*
//vip分值变化， 服务器发送客户端
const BYTE UPDATE_USER_VIP_SCORE_USERCMD_PARA = 38; 
    struct updateVipScoreUserCmd : public stSceneUserCmd 
    {   
        updateVipScoreUserCmd()
        {   
            byParam = UPDATE_USER_VIP_SCORE_USERCMD_PARA;
            vipscore = 0;
        }   
        DWORD vipscore;
    }; 
*/