package game.ui.uipaoshangsys.msg 
{
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqChangeBusinessUserCmd extends stBusinessCmd
	{
		public function reqChangeBusinessUserCmd() 
		{
			super();
			byParam = stBusinessCmd.REQ_CHANGE_BUSINESS_USERCMD;
		}
	}
}

//请求换货 ， 换货成功返回 6号消息
//const BYTE REQ_CHANGE_BUSINESS_USERCMD = 7;
//struct reqChangeBusinessUserCmd : public stBusinessCmd
//{
	//reqChangeBusinessUserCmd()
	//{
		//byParam = REQ_CHANGE_BUSINESS_USERCMD;
	//}
//};