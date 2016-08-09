package modulecommon.net.msg.wunvCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stWuNvCmd extends stNullUserCmd 
	{
		public static const NOTIFY_WUNV_DATA_USERCMD:uint = 1;
		public static const REQ_OPEN_WU_NV_UI_USERCMD:uint = 2;
		public static const RET_OPEN_WU_NV_UI_USERCMD:uint = 3;
		public static const REQ_BEGIN_WU_NV_DANCING_USERCMD:uint = 4; 
		public static const RET_BEGIN_WU_NV_DANCING_USERCMD:uint = 5;
		public static const REQ_FRIEND_WU_NV_DANCING_USERCMD:uint = 6;
		public static const RET_FRIEND_WU_NV_DANCING_USERCMD:uint = 7;
		public static const REQ_PROCESS_FRIEND_WU_NV_STATE_USERCMD:uint = 8; 
		public static const RET_PROCESS_FRIEND_WU_NV_STATE_USERCMD:uint = 9;
		public static const REQ_GET_WU_NV_OUT_PUT_USERCMD:uint = 10;
		public static const RET_GET_WU_NV_OUT_PUT_USERCMD:uint = 11;
		public static const REQ_STEAL_WU_NV_OUT_PUT_USERCMD:uint = 12; 
		public static const NOTIFY_ADD_NEW_WUNV_USERCMD:uint = 13;
		public static const NOTIFY_WUNV_REAP_DATA_USERCMD:uint = 14; 
		public static const NOTIFY_ADD_NEW_MYSTERY_WUNV_USERCMD:uint = 15; 
		public static const NOTIFY_DEL_WUNV_USERCMD:uint = 16;
		public static const UPDATE_WUNV_STEAL_DATA_USERCMD:uint = 18;
		public function stWuNvCmd() 
		{
			byCmd = WUNV_USERCMD; 
		}
		
	}

}


/*	struct stWuNvCmd : public stNullUserCmd
	{
		stWuNvCmd()
		{
			byCmd = WUNV_USERCMD; //26
		}
	};*/