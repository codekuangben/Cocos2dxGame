package modulecommon.net.msg.paoshangcmd
{
	/**
	 * ...
	 * @author ...
	 */
	public class reqOpenBusinessUiUserCmd extends stBusinessCmd
	{
		public function reqOpenBusinessUiUserCmd()
		{
			super();
			byParam = stBusinessCmd.REQ_OPEN_BUSINESS_UI_USERCMD;
		}
	}
}

//const BYTE REQ_OPEN_BUSINESS_UI_USERCMD = 3;
//struct reqOpenBusinessUiUserCmd : public stBusinessCmd
//{
	//reqOpenBusinessUiUserCmd()
	//{
		//byParam = REQ_OPEN_BUSINESS_UI_USERCMD;
	//}
//};