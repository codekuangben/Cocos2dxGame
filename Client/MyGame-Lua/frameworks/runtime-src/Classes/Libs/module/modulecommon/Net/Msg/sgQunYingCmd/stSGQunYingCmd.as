package modulecommon.net.msg.sgQunYingCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stSGQunYingCmd extends stNullUserCmd 
	{
		public static const PARA_NOTIFY_CROSS_SERVER_ISREADY_CMD:uint = 1;
		public static const PARA_REQ_CROSS_SERVER_DATA_CMD:uint = 2;
		public static const PARA_QUNYINGHUI_ONLINE_CMD:uint = 3;
		public static const PARA_REQ_QUN_YING_HUI_RANK_CMD:uint = 4;
		public static const PARA_RET_QUN_YING_HUI_RANK_CMD:uint = 5;
		public static const PARA_MATCH_USER_INFO_CMD:uint = 6;
		public static const PARA_UPDATE_USER_INFO_CMD:uint = 7;
		public static const PARA_UPDATE_USER_ZHANJI_CMD:uint = 8;
		public static const PARA_VIEW_USER_ZHANJI_CMD:uint = 9;
		public static const PARA_GET_VIC_BOX_CMD:uint = 10;
		public function stSGQunYingCmd() 
		{
			super();
			byCmd = SGQUNYINGHUI_USERCMD;
		}
		
	}

}

///三国群英会相关指令
	/*struct stSGQunYingCmd : public stNullUserCmd
	{
		stSGQunYingCmd()
		{
			byCmd = SGQUNYINGHUI_USERCMD;
		}
	};*/