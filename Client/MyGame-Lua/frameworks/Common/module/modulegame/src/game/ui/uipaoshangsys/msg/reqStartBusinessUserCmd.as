package game.ui.uipaoshangsys.msg 
{
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqStartBusinessUserCmd extends stBusinessCmd
	{
		public function reqStartBusinessUserCmd()
		{
			super();
			byParam = stBusinessCmd.REQ_START_BUSINESS_USERCMD;
		}
	}
}

//请求出车
//const BYTE REQ_START_BUSINESS_USERCMD = 8;
//struct reqStartBusinessUserCmd : public stBusinessCmd
//{
	//reqStartBusinessUserCmd()
	//{
		//byParam = REQ_START_BUSINESS_USERCMD;
	//}
//};