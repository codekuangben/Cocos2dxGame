package game.netmsg.corpscmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.corpscmd.stCorpsCmd;

	public class updateRegJoinCorpsFightStateUserCmd extends stCorpsCmd
	{
		public var reg:uint;

		public function updateRegJoinCorpsFightStateUserCmd()
		{
			super();
			byParam = stCorpsCmd.UPDATE_REG_JOIN_CORPS_FIGHT_STATE_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			reg = byte.readUnsignedByte();
		}
	}
}

//更新争霸战报名状态
//const BYTE UPDATE_REG_JOIN_CORPS_FIGHT_STATE_USERCMD = 78;
//struct updateRegJoinCorpsFightStateUserCmd : public stCorpsCmd
//{
//	updateRegJoinCorpsFightStateUserCmd()
//	{
//		byParam = UPDATE_REG_JOIN_CORPS_FIGHT_STATE_USERCMD;
//		reg = 0;
//	}
//	BYTE reg; //0:未报名 1:已报名
//};