package game.netmsg.teamcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class takeOffTeamMemberUserCmd extends stTeamCmd
	{
		public var id:uint;

		public function takeOffTeamMemberUserCmd()
		{
			super();
			byParam = stTeamCmd.TAKE_OFF_TEAM_MEMBER_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
	}
}

//通知客户端删除一个队员 s->c
//const BYTE TAKE_OFF_TEAM_MEMBER_USERCMD = 3;
//struct takeOffTeamMemberUserCmd : public stTeamCmd
//{   
//	takeOffTeamMemberUserCmd()
//	{   
//		byParam = TAKE_OFF_TEAM_MEMBER_USERCMD;
//		id = 0;
//	}   
//	DWORD id; //被踢玩家id
//};