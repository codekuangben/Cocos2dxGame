package modulecommon.net.msg.teamUserCmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.teamUserCmd.stTeamCmd;

	public class stNotifyTeamMemberListUserCmd extends stTeamCmd
	{
		public var size:uint;
		public var leader:uint;
		public var data:Vector.<TeamUser>;
		
		public function stNotifyTeamMemberListUserCmd()
		{
			super();
			byParam = stTeamCmd.NOTIFY_TEAM_MEMBER_LIST_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			data = new Vector.<TeamUser>();
			size = byte.readUnsignedByte();
			leader = byte.readUnsignedInt();
			
			var item:TeamUser;
			
			var idx:uint = 0;
			while(idx < size)
			{
				item = new TeamUser();
				item.deserialize(byte);
				data.push(item);
				++idx;
			}
		}
	}
}

//const BYTE NOTIFY_TEAM_MEMBER_LIST_USERCMD = 1;
//struct stNotifyTeamMemberListUserCmd : public stTeamCmd
//{
//	stNotifyTeamMemberListUserCmd()
//	{
//		byParam = NOTIFY_TEAM_MEMBER_LIST_USERCMD;
//	}
//	BYTE size;
//	DWORD leader;
//	TeamUser data[0];
//	WORD getSize() const { return sizeof(*this) + sizeof(TeamUser)*size; }
//};