package game.ui.uiWorldMap.netmsg
{
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import flash.utils.ByteArray;
	
	public class reqGotoMapUserCmd extends stSceneUserCmd
	{
		public var mapid:uint;
		public function reqGotoMapUserCmd()
		{
			byParam = SceneUserParam.REQ_GOTO_MAP_USERCMD_PARA;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(mapid);
		}
	}
}

/*
const BYTE REQ_GOTO_MAP_USERCMD_PARA = 21; 
struct reqGotoMapUserCmd : public stSceneUserCmd
{   
reqGotoMapUserCmd()
{   
byParam = REQ_GOTO_MAP_USERCMD_PARA;
mapid = 0;
}   
DWORD mapid;    
}; 

*/