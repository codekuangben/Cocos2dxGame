package game.netmsg.sceneUserCmd
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import game.netmsg.sceneUserCmd.stmsg.FakeUserDataPos;
	//import game.netmsg.sceneUserCmd.stmsg.UserDataPos;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	public class stSendNineScreenFakeUserDataUserCmd extends stSceneUserCmd 
	{
		public var size:uint;
		//public var data:Vector.<UserDataPos>;
		public var data:Vector.<FakeUserDataPos>;
		public function stSendNineScreenFakeUserDataUserCmd() 
		{
			super();
			byParam = SceneUserParam.SEND_NINE_SCREEN_FAKE_USERDATA_USERCMD_PARA;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			size = byte.readShort();
			//data ||= new Vector.<UserDataPos>();
			data ||= new Vector.<FakeUserDataPos>();
			data.splice(0, data.length);
			//var pos:UserDataPos;
			var pos:FakeUserDataPos;
			
			var idx:uint = 0;
			while (idx < size)
			{
				//pos = new UserDataPos();
				pos = new FakeUserDataPos();
				data.push(pos);
				pos.deserialize(byte);
				
				++idx;
			}
		}
	}
}

/*
 * // 发送9屏假玩家数据给玩家
        const BYTE SEND_NINE_SCREEN_FAKE_USERDATA_USERCMD_PARA = 23; 
        struct stSendNineScreenFakeUserDataUserCmd : public stSceneUserCmd
    {   
        stSendNineScreenFakeUserDataUserCmd()
        {   
            byParam = SEND_NINE_SCREEN_FAKE_USERDATA_USERCMD_PARA;
        }   
        WORD size;
        //UserDataPos data[0];
		FakeUserDataPos data[0];
        WORD getSize() { return sizeof(*this) + size* sizeof(UserDataPos); }
    };
*/