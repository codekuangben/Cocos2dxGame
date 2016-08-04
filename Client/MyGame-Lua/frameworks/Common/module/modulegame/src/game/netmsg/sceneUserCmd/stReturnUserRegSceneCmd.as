package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 * //返回注册场景用户
		const BYTE RETURN_USER_REG_SCENE_PARA = 1;
		struct stReturnUserRegSceneCmd  : public stSceneUserCmd
		{
				stReturnUserRegSceneCmd()
				{
						byParam = RETURN_USER_REG_SCENE_PARA;
						byResult  = 0;
				}
				BYTE byResult ;//0成功, 1失败
		};

	 */
	public final class stReturnUserRegSceneCmd extends stSceneUserCmd
	{
		public var byResult : int;	//0成功, 1失败
		public function stReturnUserRegSceneCmd() 
		{
			byParam = SceneUserParam.RETURN_USER_REG_SCENE_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			byResult = byte.readByte();
		}
	}

}