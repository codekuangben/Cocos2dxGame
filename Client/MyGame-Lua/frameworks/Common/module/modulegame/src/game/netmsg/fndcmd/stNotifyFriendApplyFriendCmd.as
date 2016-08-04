package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stNotifyFriendApplyFriendCmd extends stFriendCmd
	{
		public var applyinfo:stUBaseInfo;
		
		public function stNotifyFriendApplyFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_NOTIFY_FRIEND_APPLY_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			applyinfo = new stUBaseInfo();
			applyinfo.deserialize(byte);
		}
	}
}

//通知好友申请
//const BYTE PARA_NOTIFY_FRIEND_APPLY_FRIENDCMD = 10;
//struct stNotifyFriendApplyFriendCmd : public stFriendCmd
//{
//	stNotifyFriendApplyFriendCmd()
//	{
//		byParam = PARA_NOTIFY_FRIEND_APPLY_FRIENDCMD;
//		bzero(applyinfo,sizeof(applyinfo));
//	}
//	stUBaseInfo applyinfo;
//};