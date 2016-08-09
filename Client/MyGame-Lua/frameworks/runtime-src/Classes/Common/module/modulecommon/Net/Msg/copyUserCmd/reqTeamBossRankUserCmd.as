package modulecommon.net.msg.copyUserCmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class reqTeamBossRankUserCmd extends stCopyUserCmd
	{
		public function reqTeamBossRankUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_TEAM_BOSS_RANK_USERCMD;
		}
	}
}

//请求组队闯关排行榜
//const BYTE REQ_TEAM_BOSS_RANK_USERCMD = 63;
//struct reqTeamBossRankUserCmd: public stCopyUserCmd
//{
//	reqTeamBossRankUserCmd()
//	{
//		byParam = REQ_TEAM_BOSS_RANK_USERCMD;
//	}
//};