package game.netmsg.sceneUserCmd
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import flash.utils.ByteArray;
	
	public class stBatchRemoveUserMapScreenUserCmd extends stSceneUserCmd
	{
		public var num:uint;
		public var id:Vector.<uint>;
		
		public function stBatchRemoveUserMapScreenUserCmd()
		{
			super();
			byParam = SceneUserParam.BATCHREMOVEUSER_MAPSCREEN_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			
			id = new Vector.<uint>();
			var idx:uint = 0;
			while(idx < num)
			{
				id.push(byte.readUnsignedInt());
				++idx;
			}
		}
	}
}

//const BYTE BATCHREMOVEUSER_MAPSCREEN_USERCMD_PARA = 10; 
//struct stBatchRemoveUserMapScreenUserCmd : public stSceneUserCmd 
//{   
//	stBatchRemoveUserMapScreenUserCmd()
//	{
//		byParam = BATCHREMOVEUSER_MAPSCREEN_USERCMD_PARA;
//	}
//	WORD  num;
//	DWORD   id[0];
//};