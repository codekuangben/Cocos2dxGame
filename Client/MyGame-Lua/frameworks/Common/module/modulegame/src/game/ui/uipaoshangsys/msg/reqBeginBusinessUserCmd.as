package game.ui.uipaoshangsys.msg 
{
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqBeginBusinessUserCmd extends stBusinessCmd
	{
		public function reqBeginBusinessUserCmd()
		{
			super();
			byParam = stBusinessCmd.REQ_BEGIN_BUSINESS_USERCMD;
		}
	}
}

//请求跑商
//const BYTE REQ_BEGIN_BUSINESS_USERCMD = 5;
//struct reqBeginBusinessUserCmd : public stBusinessCmd
//{
	//reqBeginBusinessUserCmd()
	//{
		//byParam = REQ_BEGIN_BUSINESS_USERCMD;
	//}
//};