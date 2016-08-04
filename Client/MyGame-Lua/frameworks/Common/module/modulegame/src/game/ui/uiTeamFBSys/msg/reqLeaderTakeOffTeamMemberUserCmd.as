package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class reqLeaderTakeOffTeamMemberUserCmd extends stTeamCmd
	{
		public var teamid:uint;
		public var id:uint;
		
		public function reqLeaderTakeOffTeamMemberUserCmd()
		{
			super();
			byParam = stTeamCmd.REQ_LEADER_TAKE_OFF_TEAM_MEMBER_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(teamid);
			byte.writeUnsignedInt(id);
		}
	}
}

//队长请求将某人踢出队伍，同时踢出副本 c->s
//const BYTE REQ_LEADER_TAKE_OFF_TEAM_MEMBER_USERCMD = 2;
//struct reqLeaderTakeOffTeamMemberUserCmd : public stTeamCmd
//{
//	reqLeaderTakeOffTeamMemberUserCmd()
//	{
//		byParam = REQ_LEADER_TAKE_OFF_TEAM_MEMBER_USERCMD;
//		teamid = id = 0;
//	}
//	DWORD teamid;
//	DWORD id; //被踢玩家id
//};