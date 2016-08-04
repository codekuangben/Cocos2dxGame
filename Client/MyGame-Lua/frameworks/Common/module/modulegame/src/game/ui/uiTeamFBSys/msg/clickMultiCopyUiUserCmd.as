package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class clickMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public var copyid:uint;
		public var type:uint;

		public function clickMultiCopyUiUserCmd()
		{
			super();
			byParam = stCopyUserCmd.PARA_CLICK_MULTI_COPY_UI_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(copyid);
			byte.writeByte(type);
		}
	}
}

//点击一个副本
//const BYTE PARA_CLICK_MULTI_COPY_UI_USERCMD = 39;
//struct clickMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	clickMultiCopyUiUserCmd()
//	{
//		byParam = PARA_CLICK_MULTI_COPY_UI_USERCMD;
//		copyid = 0;
//		type = 0;
//	}
//	DWORD copyid;
//	BYTE type; //0:显示全部 1:显示本军团
//};