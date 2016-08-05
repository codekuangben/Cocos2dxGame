package game.netmsg.copycmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class synTeamBossTodayCengUserCmd extends stCopyUserCmd
	{
		public var count:uint;
		public var max:uint;

		public function synTeamBossTodayCengUserCmd()
		{
			super();
			byParam = stCopyUserCmd.SYN_TEAM_BOSS_TODAY_CENG_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			count = byte.readUnsignedShort();
			max = byte.readUnsignedShort();
		}
	}
}

//同步今日打到第多少层
//const BYTE SYN_TEAM_BOSS_TODAY_CENG_USERCMD = 62;
//struct synTeamBossTodayCengUserCmd: public stCopyUserCmd
//{
//	synTeamBossTodayCengUserCmd()
//	{
//		byParam = SYN_TEAM_BOSS_TODAY_CENG_USERCMD;
//		count = max = 0;
//	}
//	WORD count; //今日第多少层
//	WORD max; //历史最高层
//};