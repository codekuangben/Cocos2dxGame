package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author 
	 * 竞技场
	 */
	public class stGuanZhiJingJiCmd extends stNullUserCmd 
	{
		public static const REQ_OPEN_GUAN_ZHI_JING_JI_USERCMD:uint = 1;
		public static const REQ_CLOSE_GUAN_ZHI_JING_JI_USERCMD:uint = 2;
		public static const RET_RANK_LIST_USERCMD:uint = 3;
		public static const REQ_GUAN_ZHI_JING_JI_PK_USERCMD:uint = 4;
		
		public static const RET_GUAN_ZHI_JING_JI_REVIEW_LIST:uint = 5;
		public static const REQ_GUAN_ZHI_JING_JI_REVIEW_PK:uint = 6;
		
		public static const GUAN_ZHI_JING_JI_PK_COUNT_USERCMD:uint = 8;
		public static const GUAN_ZHI_JING_JI_PK_DAO_JI_SHI_USERCMD:uint = 9;
		public static const REQ_30_RANK_LIST_USERCMD:uint = 10;
		public static const RET_30_RANK_LIST_USERCMD:uint = 11;
		
		public static const NOTIFY_GUANZHI_NAME_USERCMD:uint = 12;			//发送官职名
		public static const NOTIFY_CLEAR_GUANZHI_NAME_USERCMD:uint = 13;	//清除官职名
		public static const UPDATE_ONE_GUAN_ZHI_JING_JI_REVIEW:uint = 14;
		public static const NOTIFY_THREE_FIXED_CHARID_USERCMD:uint = 15;
		public static const NOTIFY_NINE_GUANZHI_NAME_USERCMD:uint = 16;		//发送官职名
		public static const REQ_GET_GUANZHI_USERCMD:uint = 17;				//请求领取俸禄
		
		public function stGuanZhiJingJiCmd()
		{
			byCmd = GUANZHI_USERCMD; //15
		}
	}
}

/*struct stGuanZhiJingJiCmd : public stNullUserCmd
	{
		stGuanZhiJingJiCmd()
		{
			byCmd = GUANZHI_USERCMD; //15
		}
	};*/