package game.netmsg.sceneUserCmd
{
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	import flash.utils.ByteArray;
	
	public class stBatchRemoveNpcMapScreenUserCmd extends stSceneUserCmd
	{
		public var num:uint;
		public var id:Vector.<uint>;
		
		public function stBatchRemoveNpcMapScreenUserCmd()
		{
			super();
			byParam = SceneUserParam.BATCHREMOVENPC_MAPSCREEN_USERCMD_PARA;
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

// 批量删除NPC指令
//const BYTE BATCHREMOVENPC_MAPSCREEN_USERCMD_PARA = 9;
//struct stBatchRemoveNpcMapScreenUserCmd : public stSceneUserCmd 
//{   
//	stBatchRemoveNpcMapScreenUserCmd()
//	{    
//		byParam = BATCHREMOVENPC_MAPSCREEN_USERCMD_PARA;
//	}   
//	WORD  num;
//	DWORD   id[0];
//};