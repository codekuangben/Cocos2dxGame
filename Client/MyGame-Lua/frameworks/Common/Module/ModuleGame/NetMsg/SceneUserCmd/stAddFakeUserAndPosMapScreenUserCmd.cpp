package game.netmsg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import game.netmsg.sceneUserCmd.stmsg.FakeUserDataPos;
	import game.netmsg.sceneUserCmd.stmsg.UserDataPos;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	
	public class stAddFakeUserAndPosMapScreenUserCmd extends stSceneUserCmd 
	{
		//public var data:UserDataPos;
		public var data:FakeUserDataPos;
		public function stAddFakeUserAndPosMapScreenUserCmd() 
		{
			byParam = SceneUserParam.ADD_FAKE_USER_AND_POS_MAPSCREEN_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			//data ||= new UserDataPos();
			data ||= new FakeUserDataPos();
			data.deserialize(byte);
		}
	}
}

/*
 *  //发送假人物信息给9屏玩家
        const BYTE ADD_FAKE_USER_AND_POS_MAPSCREEN_USERCMD_PARA = 22;
        struct stAddFakeUserAndPosMapScreenUserCmd : public stSceneUserCmd
    {
        stAddFakeUserAndPosMapScreenUserCmd()
        {
            byParam = ADD_FAKE_USER_AND_POS_MAPSCREEN_USERCMD_PARA;
        }
        //UserDataPos data;
		FakeUserDataPos data;
    };

*/