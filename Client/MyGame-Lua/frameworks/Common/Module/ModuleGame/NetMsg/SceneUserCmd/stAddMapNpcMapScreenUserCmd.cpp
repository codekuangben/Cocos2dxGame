package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import game.netmsg.sceneUserCmd.stmsg.NpcDataPos;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stAddMapNpcMapScreenUserCmd extends stSceneUserCmd
	{
		public var data:NpcDataPos;
		
		public function stAddMapNpcMapScreenUserCmd() 
		{
			byParam = SceneUserParam.ADDMAPNPC_MAPSCREEN_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			data ||= new NpcDataPos();
			data.deserialize(byte);
		}
	}
}

// 在地图上增加NPC
//const BYTE ADDMAPNPC_MAPSCREEN_USERCMD_PARA = 11;
//struct stAddMapNpcMapScreenUserCmd : public stSceneUserCmd
//{
	//stAddMapNpcMapScreenUserCmd()
	//{
		//byParam = ADDMAPNPC_MAPSCREEN_USERCMD_PARA;
	//}
	//NpcDataPos data;
//};