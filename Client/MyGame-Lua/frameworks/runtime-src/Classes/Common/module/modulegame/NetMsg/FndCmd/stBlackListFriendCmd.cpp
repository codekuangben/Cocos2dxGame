package game.netmsg.fndcmd
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stBlackListFriendCmd extends stFriendCmd
	{		
		public var num:uint;
		public var blist:Array;

		public function stBlackListFriendCmd()
		{
			super();
			
			byParam = stFriendCmd.PARA_BLACK_LIST_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			var item:stUBaseInfo;
			blist ||= [];
			var idx:uint = 0;
			while(idx < num)
			{
				item = new stUBaseInfo();
				item.deserialize(byte);
				blist.push(item);
				++idx;
			}
		}
	}
}

//黑名单列表
//const BYTE PARA_BLACK_LIST_FRIENDCMD = 2;
//struct stBlackListFriendCmd. : public stFriendCmd
//{
//	stBlackListFriendCmd()
//	{
//		byParam = PARA_BLACK_LIST_FRIENDCMD;
//		num = 0;
//	}
//	WORD num;
//	stUBaseInfo blist[0];
//	WORD getSize()
//	{
//		return (sizeof(*this) + num*sizeof(stUBaseInfo));
//	}
//};