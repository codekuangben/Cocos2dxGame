package game.netmsg.sceneUserCmd 
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//将主角玩家拉到地图中的某一点
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	public class stUserGotoUserCmd extends stSceneUserCmd 
	{
		public var x:int;	//服务器坐标
		public var y:int;
		public var dir:uint;
		
		public function stUserGotoUserCmd() 
		{
			byParam = SceneUserParam.USER_GOTO_USERCMD_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
			dir = byte.readUnsignedByte();
		}
	}

}

/*
  const BYTE USER_GOTO_USERCMD_PARA = 15; 
    struct stUserGotoUserCmd : public stSceneUserCmd 
    {   
        stUserGotoUserCmd()
        {   
            byParam = USER_GOTO_USERCMD_PARA;
            x = y = 0;
        }   
        WORD x;          < 目的坐标
        WORD y;
		BYTE dir;		// 方向
    };  

*/