package modulecommon.net.msg.teamUserCmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class synUserTeamStateCmd extends stTeamCmd
	{
		public var type:uint;
		public var teamid:uint;

		public function synUserTeamStateCmd()
		{
			super();
			byParam = stTeamCmd.SYN_USER_TEAM_STATE_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			teamid = byte.readUnsignedInt();
		}
	}
}

//同步玩家队伍 s->c 客户端请根据此消息来显示或者隐藏队伍界面
//const BYTE SYN_USER_TEAM_STATE_USERCMD = 4;
//struct synUserTeamStateCmd : public stTeamCmd
//{
//	synUserTeamStateCmd()
//	{
//		byParam = SYN_USER_TEAM_STATE_USERCMD;
//		type = 0;
//		
//	}
//	BYTE type; //0:加入队伍 ， 1：离开队伍
//	DWORD teamid; //队伍id
//};