package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class retInviteAddMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public var type:uint;
		public var size:uint;
		public var data:Array;

		public function retInviteAddMultiCopyUiUserCmd()
		{
			super();
			byParam = stCopyUserCmd.RET_INVITE_ADD_MULTI_COPY_UI_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			size = byte.readUnsignedByte();
			data = [];
			var item:InviteUiData;
			var idx:uint;
			while(idx < size)
			{
				item = new InviteUiData();
				item.deserialize(byte);
				data[data.length] = item;
				++idx;
			}
		}
	}
}

//返回邀请界面数据 s->c
//const BYTE RET_INVITE_ADD_MULTI_COPY_UI_USERCMD = 42;
//struct retInviteAddMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	retInviteAddMultiCopyUiUserCmd()
//	{
//		byParam = RET_INVITE_ADD_MULTI_COPY_UI_USERCMD;
//		size = 0;
//	}
//  BYTE type;
//	BYTE size;
//	InviteUiData data[0];
//	WORD getSize() const { return sizeof(*this) + sizeof(InviteUiData)*size; }
//};