package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stChangeMapUserDataCmd extends stSceneUserCmd
	{
		public var x:Number;
		public var y:Number;
		public var dir:uint;
		public function stChangeMapUserDataCmd() 
		{
			byParam = SceneUserParam.CHANGE_MAP_USERDATA_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			x = byte.readUnsignedInt();
			y = byte.readUnsignedInt();
			dir = byte.readUnsignedByte();
		}
		
	}

}

//跳地图发送人物坐标、方向
    /*const BYTE CHANGE_MAP_USERDATA_USERCMD_PARA = 39; 
    struct stChangeMapUserDataCmd : public stSceneUserCmd 
    {   
        stChangeMapUserDataCmd()
        {   
            byParam = CHANGE_MAP_USERDATA_USERCMD_PARA;
            x = y = 0;
            dir = 0;
        }   
        DWORD x;
        DWORD y;
        BYTE dir;
    };  
*/