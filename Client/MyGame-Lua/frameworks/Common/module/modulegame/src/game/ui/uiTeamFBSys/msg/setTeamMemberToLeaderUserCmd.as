package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class setTeamMemberToLeaderUserCmd extends stTeamCmd
	{
		public var id:uint;
		public var teamid:uint;

		public function setTeamMemberToLeaderUserCmd()
		{
			super();
			byParam = stTeamCmd.SET_MEMBER_TO_LEADER_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(id);
			byte.writeUnsignedInt(teamid);
		}
	}
}

//队长请求任命其它队员为队长 c->s
//const BYTE SET_MEMBER_TO_LEADER_USERCMD = 5;
//struct setTeamMemberToLeaderUserCmd : public stTeamCmd
//{
//	setTeamMemberToLeaderUserCmd()
//	{
//		byParam = SET_MEMBER_TO_LEADER_USERCMD;
//		id = 0;
//	}
//	DWORD id; //被任命玩家
//	DWORD teamid; //队伍id
//};