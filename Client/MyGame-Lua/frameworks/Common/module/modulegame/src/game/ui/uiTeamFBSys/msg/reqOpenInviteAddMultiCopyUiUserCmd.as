package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqOpenInviteAddMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public var type:uint;

		public function reqOpenInviteAddMultiCopyUiUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_OPEN_INVITE_ADD_MULTI_COPY_UI_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeByte(type);
		}
	}
}

//打开邀请加入界面 c->s
//const BYTE REQ_OPEN_INVITE_ADD_MULTI_COPY_UI_USERCMD = 42;
//struct reqOpenInviteAddMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	reqOpenInviteAddMultiCopyUiUserCmd()
//	{
//		byParam = REQ_OPEN_INVITE_ADD_MULTI_COPY_UI_USERCMD;
//		type = 0;
//	}
//	BYTE type; //0:好友 1:军团
//};