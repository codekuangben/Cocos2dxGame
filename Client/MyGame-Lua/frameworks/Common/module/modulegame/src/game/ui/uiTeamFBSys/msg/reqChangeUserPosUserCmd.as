package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqChangeUserPosUserCmd extends stCopyUserCmd
	{
		public var teamid:uint;
		public var id:uint;
		public var pos:uint;

		public function reqChangeUserPosUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_CHANGE_USER_POS_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(teamid);
			byte.writeUnsignedInt(id);
			byte.writeByte(pos);
		}
	}
}

//队长请求调整队伍布阵 c->s
//const BYTE REQ_CHANGE_USER_POS_USERCMD = 51;
//struct reqChangeUserPosUserCmd : public stCopyUserCmd
//{
//	reqChangeUserPosUserCmd()
//	{
//		byParam = REQ_CHANGE_USER_POS_USERCMD;
//		id = teamid = 0;
//		pos = 0;
//	}
//	DWORD teamid;
//	DWORD id;
//	BYTE pos;
//};