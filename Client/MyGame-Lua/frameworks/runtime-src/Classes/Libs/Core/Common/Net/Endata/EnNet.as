package common.net.endata
{
	import flash.utils.Endian;
	/**
	 * ...
	 * @author ...
	 * @brief net 基本常量，网络常量都写在这里     
	 */
	public class EnNet 
	{
		public static const CMD_NULL:uint = 0;
		public static const PARA_NULL:uint = 0;
		
		public static const NULL_USERCMD:uint = 0;
		
		// 服务器数据大端还是小端    
		public static const DATAENDIAN:String = Endian.LITTLE_ENDIAN;
		public static const MAX_IP_LENGTH:uint = 16;
		
		// 字符格式 
		public static const GB2312:String = "gb2312";
		public static const UTF8:String = "utf-8";
				
		
		public static const USER_VERIFY_VER_PARA:uint = 1;
		public static const GAME_VERSION:uint = 1999;
		
		public static const MAX_ACCNAMESIZE:uint = 48;
		public static const MAX_PASSWORD:uint = 16;
		
		
		public static const GAMETIME_TIMER_USERCMD_PARA:uint = 1;
		
		public static const MAX_NAMESIZE:uint = 48;
		public static const MAX_QUEST_NAME:uint = 48;
		public static const MAX_NSIZE:uint = 32;	//任务变量的名称
		public static const MAX_VSIZE:uint = 128;	//任务变量的值
		
		
		// 基本的消息常量 
		/*public static const RETURN_USER_VERIFY_VER_PARA:uint = 2;
		public static const USER_REQUEST_LOGIN_PARA:uint = 3;
		
		public static const SERVER_RETURN_LOGIN_FAILED:uint = 4;
		public static const SERVER_RETURN_LOGIN_OK:uint = 5;
		public static const PASSWD_LOGON_USERCMD_PARA:uint = 6;
		public static const RETURN_NO_CHAR_USERCMD_PARA:uint = 7;
		public static const CREATE_CHAR_USERCMD_PARA:uint = 8;
		public static const RETURN_RELEASE_VER_PARA:uint = 9;*/
		
		//byCmd = EnNet.SCENE_USERCMD;		
			
		
		public static var NETSTATE_NONE:uint = 0;	// 初始状态    
		public static var NETSTATE_LOGINING:uint = 1;	// 正在登录登录服务器   
		public static var NETSTATE_LOGINFAILED:uint = 2;	// 登录登录服务器失败 
		public static var NETSTATE_LOGINDUCCESS:uint = 3;	// 登录登录服务成功 
		public static var NETSTATE_GATEWAYING:uint = 4;	// 正在登录网关服务器      
		public static var NETSTATE_GATEWAYFAILED:uint = 5;	// 登录网关服务器失败 
		public static var NETSTATE_GATEWAYSUCCESS:uint = 6;	// 登录网关服务器成功
		
		public static const MAX_MOODDIARY_LEN:uint = 128;
		public static const MAX_FRIEND_NUM:uint = 50;
		public static const MAX_BLACKLIST_NUM:uint = 20;
	}
}

//const BYTE CMD_NULL = 0;    /**< 空的指令 */
//const BYTE PARA_NULL = 0;  /**< 空的指令参数 */

// 空指令
//const BYTE NULL_USERCMD      = 0;
// 登陆指令
//const BYTE LOGON_USERCMD    = 1;
// 时间指令
//const BYTE TIME_USERCMD      = 2;

/// 客户端验证版本
//const BYTE USER_VERIFY_VER_PARA = 1;
//const DWORD GAME_VERSION = 1999;