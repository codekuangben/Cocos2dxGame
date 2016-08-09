package modulecommon.net.msg.paoshangcmd
{
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * @author ...
	 */
	public class stBusinessCmd extends stNullUserCmd
	{
		//public static const PARA_REQ_BUSINESS_SERVER_DATA_CMD:uint = 1;
		//public static const NOTIFY_BUSINESS_DATA_USERCMD:uint = 2;
		//public static const ADD_ONE_ROBER_INFO_USERCMD:uint = 3;
		public static const REQ_OPEN_BUSINESS_UI_USERCMD:uint = 1;
		public static const RET_BUSINESS_UI_DATA_USERCMD:uint = 2;
		
		public static const REQ_BEGIN_BUSINESS_USERCMD:uint = 3;
		public static const RET_BEGIN_BUSINESS_USERCMD:uint = 4;
		public static const REQ_CHANGE_BUSINESS_USERCMD:uint = 5;
		public static const REQ_START_BUSINESS_USERCMD:uint = 6;
		
		public static const RET_START_BUSINESS_USERCMD:uint = 7;
		public static const REQ_ROB_BUSINESS_USERCMD:uint = 8;
		
		public function stBusinessCmd()
		{
			super();
			byCmd = stNullUserCmd.BUSINESS_USERCMD;
		}	
	}
}

//struct stBusinessCmd : public stNullUserCmd
//{
	//stBusinessCmd()
	//{
		//byCmd = BUSINESS_USERCMD; //30
	//}
//};