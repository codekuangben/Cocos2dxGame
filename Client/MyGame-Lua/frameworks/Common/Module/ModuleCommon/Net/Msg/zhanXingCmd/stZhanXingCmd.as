package modulecommon.net.msg.zhanXingCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stZhanXingCmd extends stNullUserCmd 
	{		
		public static const PARA_ZHAN_XING_INFO_ZXCMD:uint = 1;
		public static const PARA_ALL_SHENBING_INFO_ZXCMD:uint = 2;
		public static const PARA_REQ_VISIT_ZXCMD:uint = 3;
		public static const PARA_LIGHT_HERO_ZXCMD:uint = 4;
		public static const PARA_ADD_SHENBING_ZXCMD:uint = 5;
		public static const PARA_REMOVE_SHENBING_ZXCMD:uint = 6;
		public static const PARA_SWAP_SHENBING_ZXCMD:uint = 7;
		public static const PARA_SWALLOW_SHENBING_ZXCMD:uint = 8;
		public static const PARA_ONEKEY_COMPOSE_SHENBING_ZXCDM:uint = 9;
		public static const PARA_REQ_OPEN_GEZI_ZXCMD:uint = 10;
		public static const PARA_REFRESH_OPENED_GEZI_NUM_ZXCMD:uint = 11;
		public static const PARA_REFRESH_MINGLI_ZXCMD:uint = 12;
		public static const PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD:uint = 13;
		public static const PARA_REFRESH_ZXSCORE_ZXCMD:uint = 14;
		public static const PARA_WUXUE_EXCHANGE_ZXCMD:uint = 15;
		public static const GM_PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD:uint = 16;
		public static const PARA_REFRESH_SILVER_VISIT_TIMES_WUXUE_CMD:uint = 17;
		public function stZhanXingCmd() 
		{
			super();
			byCmd = ZHANXING_USERCMD;
		}
		
	}

}

///占星相关指令
	/*struct stZhanXingCmd : public stNullUserCmd
	{
		stZhanXingCmd()
		{
			byCmd = ZHANXING_USERCMD;
		}
	};*/