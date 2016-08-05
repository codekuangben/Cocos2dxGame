package game.netmsg.fndcmd
{
	import modulecommon.net.msg.fndcmd.stFriendCmd;
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.relation.stUBaseInfo;

	public class stFriendListFriendCmd extends stFriendCmd
	{
		public var num:uint;
		public var flist:Array;

		public function stFriendListFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_FRIEND_LIST_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			num = byte.readUnsignedShort();
			var item:stUBaseInfo;
			flist ||= [];
			var idx:int = 0;
			var lstidx:int = 0;	// 在列表中插入的时候的索引
			while(idx < num)
			{
				item = new stUBaseInfo();
				item.deserialize(byte);
				// 从后向前插入,前面是在线的,后面是不在线的
				if(item.online == 1)	// 在线
				{
					lstidx = flist.length - 1;
					while(lstidx >= 0)
					{
						if((flist[lstidx] as stUBaseInfo).online == 1)
						{
							break;
						}
						
						--lstidx;
					}
					// 插入元素
					flist.splice(lstidx + 1, 0, item);
				}
				else	// 不在线直接放在最后
				{
					flist.push(item);
				}
				++idx;
			}
		}
	}
}

//好友列表
//const BYTE PARA_FRIEND_LIST_FRIENDCMD = 1;
//struct stFriendListFriendCmd : public stFriendCmd
//{
//	stFriendListFriendCmd()
//	{
//		byParam = PARA_FRIEND_LIST_FRIENDCMD;
//		num = 0;
//	}
//	WORD num;
//	stUBaseInfo flist[0];
//	WORD getSize()
//	{
//		return (sizeof(*this) + num*sizeof(stUBaseInfo));
//	}
//};