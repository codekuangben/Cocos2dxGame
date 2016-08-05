package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import game.netmsg.sceneUserCmd.stmsg.UserDataPos;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAddUserAndPosMapScreenUserCmd extends stSceneUserCmd
	{
		public var data:UserDataPos;
		
		public function stAddUserAndPosMapScreenUserCmd() 
		{
			super();
			byParam = SceneUserParam.ADD_USER_AND_POS_MAPSCREEN_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			data ||= new UserDataPos();
			data.deserialize(byte);
		}
	}
}

//发送人物信息给9屏玩家
//const BYTE ADD_USER_AND_POS_MAPSCREEN_USERCMD_PARA = 5;
//struct stAddUserAndPosMapScreenUserCmd : public stSceneUserCmd
//{
	//stAddUserAndPosMapScreenUserCmd()
	//{
		//byParam = ADD_USER_AND_POS_MAPSCREEN_USERCMD_PARA;
	//}
	//UserDataPos data;
//};