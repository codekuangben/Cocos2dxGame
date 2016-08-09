package game.netmsg.sceneUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRemoveEntryMapScreenUserCmd extends stSceneUserCmd
	{
		public var tempid:uint;
		public var type:uint;
		
		public function stRemoveEntryMapScreenUserCmd() 
		{
			super();
			byParam = SceneUserParam.REMOVE_ENTRY_MAPSCREEN_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			tempid = byte.readUnsignedInt();
			type = byte.readUnsignedByte();
		}
	}
}

//地图上面删除一个人or npc
//const BYTE REMOVE_ENTRY_MAPSCREEN_USERCMD_PARA = 8;
//struct stRemoveEntryMapScreenUserCmd : public stSceneUserCmd
//{
	//stRemoveEntryMapScreenUserCmd()
	//{
		//byParam = REMOVE_ENTRY_MAPSCREEN_USERCMD_PARA;
	//}
	//DWORD tempid;
	//BYTE type ; //0:人物, 1:npc 2:假人物 

//};