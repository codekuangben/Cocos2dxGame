package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retChangeUserPosUserCmd extends stCopyUserCmd
	{
		public var id:uint;
		public var pos:uint;
		
		public var src:int;		// 原始的位置，客户端使用，不是消息中的数据
		
		public function retChangeUserPosUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_CHANGE_USER_POS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
			pos = byte.readUnsignedByte();
		}
	}
}

//返回请求调整队伍布阵 s->c (队长调整后，队伍所有 人都会收到此消息)
//const BYTE RET_CHANGE_USER_POS_USERCMD = 52;
//struct retChangeUserPosUserCmd : public stCopyUserCmd
//{
//	retChangeUserPosUserCmd()
//	{
//		byParam = RET_CHANGE_USER_POS_USERCMD;
//	}
//	DWORD id;
//	BYTE pos ;
//};