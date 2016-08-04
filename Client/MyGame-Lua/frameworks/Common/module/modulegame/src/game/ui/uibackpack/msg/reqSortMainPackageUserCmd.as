package game.ui.uibackpack.msg 
{
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class reqSortMainPackageUserCmd extends stPropertyUserCmd 
	{
		
		public function reqSortMainPackageUserCmd() 
		{
			byParam = REQ_SORT_MAIN_PACKAGE_USERCMD;			
		}
		
	}

}

//请求整理背包
	/*const BYTE REQ_SORT_MAIN_PACKAGE_USERCMD = 37;
	struct reqSortMainPackageUserCmd : public stPropertyUserCmd
	{
		reqSortMainPackageUserCmd()
		{
			byParam = REQ_SORT_MAIN_PACKAGE_USERCMD;
		}
	};*/
