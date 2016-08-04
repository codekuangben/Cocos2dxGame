package game.ui.uiTeamFBSys.msg
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class quickInviteOtherAddMultiCopyUserCmd extends stCopyUserCmd
	{
		public function quickInviteOtherAddMultiCopyUserCmd()
		{
			byParam = stCopyUserCmd.QUICK_INVITE_OTHER_ADD_MULTI_COPY_USERCMD;
		}
	}
}

//快速邀请加入多人副本 c->s
//const BYTE QUICK_INVITE_OTHER_ADD_MULTI_COPY_USERCMD = 48; 
//struct quickInviteOtherAddMultiCopyUserCmd : public stCopyUserCmd
//{   
//	quickInviteOtherAddMultiCopyUserCmd()
//	{   
//		byParam = QUICK_INVITE_OTHER_ADD_MULTI_COPY_USERCMD;
//	}   
//};