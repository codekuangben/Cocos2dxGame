package net.loginUserCmd
{
	import common.net.msg.basemsg.stNullUserCmd;
	//import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stLoginUserCmd extends stNullUserCmd
	{
		public static const RETURN_USER_VERIFY_VER_PARA:uint = 2;	//stReturnUserVerifyVerCmd.目前收到此消息,没做任何处理
		public static const USER_REQUEST_LOGIN_PARA:uint = 3;	//stUserRequestLoginCmd
		
		public static const SERVER_RETURN_LOGIN_FAILED:uint = 4;
		public static const SERVER_RETURN_LOGIN_OK:uint = 5;	//stServerReturnLoginSuccessCmd
		public static const PASSWD_LOGON_USERCMD_PARA:uint = 6;	//stPasswdLogonUserCmd
		public static const RETURN_NO_CHAR_USERCMD_PARA:uint = 7;
		public static const CREATE_CHAR_USERCMD_PARA:uint = 8;
		public static const RETURN_RELEASE_VER_PARA:uint = 9;
		public static const SYN_LAND_ZONE_PARA:uint = 10;	//synLandZoneUserCmd 通知客户端登陆其他区
		public static const PLATFORM_USER_REQUEST_LOGIN_PARA:uint = 11;
		public static const CLIENT_RESOURCE_LOADOVER_LOGIN_PARA:uint = 12;
		public static const SERVER_RETURN_DISCONNECT:uint = 13;
		public static const PARA_LOAD_SELECT_CHARACTER_UI_OVER_CMD:uint = 14;
		public function stLoginUserCmd() 
		{
			super();
			byCmd = LOGON_USERCMD;
		}	
	}
}

//struct stLogonUserCmd : public stNullUserCmd
//{
	//stLogonUserCmd()
	//{
		//byCmd = LOGON_USERCMD;
	//}
//};