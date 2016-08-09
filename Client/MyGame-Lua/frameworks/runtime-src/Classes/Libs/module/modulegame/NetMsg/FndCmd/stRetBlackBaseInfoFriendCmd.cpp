package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stRetBlackBaseInfoFriendCmd extends stFriendCmd
	{
		public var fbase:stUBaseInfo;

		public function stRetBlackBaseInfoFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_RET_BLACK_BASEINFO_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			fbase = new stUBaseInfo();
			fbase.deserialize(byte);
		}
	}
}

//拉黑一个玩家，返回拉黑信息
//const BYTE PARA_RET_BLACK_BASEINFO_FRIENDCMD = 19; 
//struct stRetBlackBaseInfoFriendCmd : public stFriendCmd
//{   
//	stRetBlackBaseInfoFriendCmd()
//	{   
//		byParam = PARA_RET_BLACK_BASEINFO_FRIENDCMD;
//		bzero(&fbase,sizeof(fbase));
//	}   
//	stUBaseInfo fbase;
//};