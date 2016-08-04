package game.ui.uiTeamFBSys.msg
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqOpenAssginHeroUiCopyUserCmd extends stCopyUserCmd
	{
		public function reqOpenAssginHeroUiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_OPEN_ASSGIN_HERO_UI_USERCMD;
		}
	}
}

//请求打开队伍布阵界面 c->s
//const BYTE REQ_OPEN_ASSGIN_HERO_UI_USERCMD = 49;
//struct reqOpenAssginHeroUiCopyUserCmd : public stCopyUserCmd
//{
//	reqOpenAssginHeroUiCopyUserCmd()
//	{
//		byParam = REQ_OPEN_ASSGIN_HERO_UI_USERCMD;
//	}
//};