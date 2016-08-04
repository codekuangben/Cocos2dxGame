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
	public class stSendNineScreenNpcDataUserCmd extends stSceneUserCmd
	{
		public var size:uint;
		public var data:Vector.<NpcDataPos>;
		
		public function stSendNineScreenNpcDataUserCmd() 
		{
			super();
			byParam = SceneUserParam.SEND_NINE_SCREEN_NPCDATA_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			size = byte.readShort();
			data ||= new Vector.<NpcDataPos>();
			data.splice(0, data.length);
			var pos:NpcDataPos;
			
			var idx:uint = 0;
			while (idx < size)
			{
				pos = new NpcDataPos();
				data.push(pos);
				pos.deserialize(byte);
				
				++idx;
			}
		}
	}
}

// 发送9屏npc数据给玩家
//const BYTE SEND_NINE_SCREEN_NPCDATA_NPCCMD_PARA = 7;
//struct stSendNineScreenNpcDataUserCmd : public stSceneUserCmd
//{
	//stSendNineScreenNpcDataUserCmd()
	//{
		//byParam = SEND_NINE_SCREEN_NPCDATA_USERCMD_PARA;
	//}
	//WORD size;
	//NpcDataPos data[0];
	//WORD getSize() { return sizeof(*this) + size* sizeof(NpcDataPos); }
//};