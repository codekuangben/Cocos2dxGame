package game.ui.uiTeamFBSys.msg
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class openMultiCopyUiUserCmd extends stCopyUserCmd
	{
		public function openMultiCopyUiUserCmd()
		{
			byParam = stCopyUserCmd.PARA_OPEN_MULTI_COPY_UI_USERCMD;
		}
	}
}

//const BYTE PARA_OPEN_MULTI_COPY_UI_USERCMD = 37;
//struct openMultiCopyUiUserCmd : public stCopyUserCmd
//{
//	openMultiCopyUiUserCmd()
//	{
//		byParam = PARA_OPEN_MULTI_COPY_UI_USERCMD;
//	}
//};