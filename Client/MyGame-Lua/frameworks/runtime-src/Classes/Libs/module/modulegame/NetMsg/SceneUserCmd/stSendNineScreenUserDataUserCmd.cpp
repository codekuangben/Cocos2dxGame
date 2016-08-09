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
	public class stSendNineScreenUserDataUserCmd extends stSceneUserCmd
	{
		public var size:uint;
		public var data:Vector.<UserDataPos>;
		
		public function stSendNineScreenUserDataUserCmd() 
		{
			super();
			byParam = SceneUserParam.SEND_NINE_SCREEN_USERDATA_USERCMD_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			size = byte.readShort();
			data ||= new Vector.<UserDataPos>();
			data.splice(0, data.length);
			var pos:UserDataPos;
			
			var idx:uint = 0;
			while (idx < size)
			{
				pos = new UserDataPos();
				data.push(pos);
				pos.deserialize(byte);
				
				++idx;
			}
		}
	}
}

// 发送9屏玩家数据给玩家
//const BYTE SEND_NINE_SCREEN_USERDATA_USERCMD_PARA = 6;
//struct stSendNineScreenUserDataUserCmd : public stSceneUserCmd
//{
	//stSendNineScreenUserDataUserCmd()
	//{
		//byParam = SEND_NINE_SCREEN_USERDATA_USERCMD_PARA;
	//}
	//WORD size;
	//UserDataPos data[0];
	//WORD getSize() { return sizeof(*this) + size* sizeof(UserDataPos); }
//};