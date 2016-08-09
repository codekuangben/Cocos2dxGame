package game.netmsg.teamcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class notifyTeamMemberLeaderChangeUserCmd extends stTeamCmd
	{
		public var id:uint;

		public function notifyTeamMemberLeaderChangeUserCmd()
		{
			super();
			byParam = stTeamCmd.NOTIFY_MEMBER_LEADER_CHANGE_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
	}
}

//通知队伍内所有玩家队长变化 s->c
//const BYTE NOTIFY_MEMBER_LEADER_CHANGE_USERCMD = 6;
//struct notifyTeamMemberLeaderChangeUserCmd : public stTeamCmd
//{
//	notifyTeamMemberLeaderChangeUserCmd()
//	{
//		byParam = NOTIFY_MEMBER_LEADER_CHANGE_USERCMD;
//		id = 0;
//	}
//	DWORD id; //新队长id
//};