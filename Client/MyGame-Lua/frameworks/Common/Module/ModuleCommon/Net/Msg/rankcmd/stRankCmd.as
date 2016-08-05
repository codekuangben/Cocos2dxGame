package modulecommon.net.msg.rankcmd
{
	import common.net.msg.basemsg.stNullUserCmd;

	/**
	 * @author ...
	 */
	public class stRankCmd extends stNullUserCmd
	{
		public static const CORPS_LEVEL_RANK:uint = 0;
		public static const CORPS_ZHANLI_RANK:uint = 1;
		public static const PERSONAL_LEVEL_RANK:uint = 2;
		public static const PERSONAL_ZHANLI_RANK:uint = 3;
		public static const S7DAY_RECHARGE_RANK:uint = 4;
		
		public static const REQ_RANK_LIST_USERCMD:uint = 1;
		public static const RET_CORPS_LEVEL_RANK_LIST_USERCMD:uint = 2;
		public static const RET_CORPS_COMBAT_POWER_RANK_LIST_USERCMD:uint = 3;
		public static const PARA_PERSONAL_LEVEL_RANK_LIST_USERCMD:uint = 4;
		public static const PARA_PERSONAL_ZHANLI_RANK_LIST_USERCMD:uint = 5;
		public static const PARA_7DAY_RECHARGE_RANK_LIST_USERCMD:uint = 6;
		
		public function stRankCmd() 
		{
			super();
			byCmd = stNullUserCmd.RANK_USERCMD;
		}
	}
}

//const BYTE CORPS_LEVEL_RANK = 0; //军团等级
//const BYTE CORPS_ZHANLI_RANK = 1; //军团战力
//const BYTE PERSONAL_LEVEL_RANK = 2;	//个人等级排行榜
//const BYTE PERSONAL_ZHANLI_RANK = 3;	//个人战力排行榜
//const BYTE S7DAY_RECHARGE_RANK = 4; //第七日充值榜
//struct stRankCmd : public stNullUserCmd
//{
	//stRankCmd()
	//{
		//byCmd = RANK_USERCMD; //28
	//}
//};