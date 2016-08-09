package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stRetFriendBaseInfoFriendCmd extends stFriendCmd
	{
		public var fbase:stUBaseInfo;
		
		public function stRetFriendBaseInfoFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_RET_FRIEND_BASEINFO_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			fbase = new stUBaseInfo();
			fbase.deserialize(byte);
		}
	}
}

//加好友成功返回好友基本信息
//const BYTE PARA_RET_FRIEND_BASEINFO_FRIENDCMD = 7;
//struct stRetFriendBaseInfoFriendCmd : public stFriendCmd
//{
//	stRetFriendBaseInfoFriendCmd()
//	{
//		byParam = PARA_RET_FRIEND_BASEINFO_FRIENDCMD;
//		bzero(fbase,sizeof(fbase));
//	}
//	stUBaseInfo fbase;
//};