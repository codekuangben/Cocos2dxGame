package game.netmsg.fndcmd
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stFriendApplyListFriendCmd extends stFriendCmd
	{
		public var num:uint;
		public var applylist:Array;
		public function stFriendApplyListFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_FRIEND_APPLY_LIST_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			var item:stUBaseInfo;
			applylist ||= [];
			var idx:uint = 0;
			while(idx < num)
			{
				item = new stUBaseInfo();
				item.deserialize(byte);
				applylist.push(item);
				++idx;
			}
		}
	}
}

//好友申请列表
//const BYTE PARA_FRIEND_APPLY_LIST_FRIENDCMD = 3;
//struct stFriendApplyListFriendCmd : public stFriendCmd
//{
//	stFriendApplyListFriendCmd()
//	{
//		byParam = PARA_FRIEND_APPLY_LIST_FRIENDCMD;
//		num = 0;
//	}
//	WORD num;
//	stUBaseInfo applylist[0];
//};