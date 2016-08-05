package  app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	/*enum{
        LOGIN_RETURN_UNKNOWN = 0,   /// 未知错误
        LOGIN_RETURN_GATEWAYNOTAVAILABLE = 1,/// 网关服务器未开
        LOGIN_RETURN_ROLE_LOCK = 2,   /// 角色被锁
        LOGIN_RETURN_USERDATANOEXIST = 3,/// 用户档案不存在
        LOGIN_RETURN_TIMEOUT = 4,   /// 连接超时
        LOGIN_TICKET_TIMEOUT = 5,   //票据过期
        LOGIN_TICKET_NOT_EXIST = 6,   //票据不存在
        LOGIN_SERVICE_ERROR = 7,   //游戏标识错误
        LOGIN_PARAM_ERROR = 8,   //验证参数错误
        LOGIN_INNER_ERROR = 9,   //服务器内部错误
		LOGIN_GET_GATE_FAIL = 10,   //获取网关失败
		LOGIN_CON_SINA_FAIL = 11,   //连接新浪账号验证服务器失败
	};
	/// 登陆失败后返回的信息
	const BYTE SERVER_RETURN_LOGIN_FAILED = 4;
	struct stServerReturnLoginFailedCmd : public stLogonUserCmd
	{
		stServerReturnLoginFailedCmd()
		{
			byParam = SERVER_RETURN_LOGIN_FAILED;
		}
		BYTE byReturnCode;      //< 返回的子参数
	} ;
	*/
	
	public final class stServerReturnLoginFailedCmd extends stLoginUserCmd 
	{
		public var byReturnCode:int;	//返回的子参数
		public function stServerReturnLoginFailedCmd() 
		{
			byParam = SERVER_RETURN_LOGIN_FAILED;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			byReturnCode = byte.readUnsignedByte();
		}
		
		public static const LOGIN_RETURN_UNKNOWN:uint = 0;				// 未知错误
		public static const LOGIN_RETURN_GATEWAYNOTAVAILABLE:uint = 1;	// 网关服务器未开
		public static const LOGIN_RETURN_USERMAX:uint = 2;				// 用户满
		public static const LOGIN_RETURN_USERDATANOEXIST:uint = 3;		// 用户档案不存在
		public static const LOGIN_RETURN_TIMEOUT:uint = 4;				// 连接超时
		
		
		public static const LOGIN_TICKET_TIMEOUT:uint = 5;				// 票据过期
		public static const LOGIN_TICKET_NOT_EXIST:uint = 6;				// 票据不存在
		public static const LOGIN_SERVICE_ERROR:uint = 7;				// 游戏标识错误
		public static const LOGIN_PARAM_ERROR:uint = 8;				// 验证参数错误
		public static const LOGIN_INNER_ERROR:uint = 9;				// 服务器内部错误
		public static const LOGIN_GET_GATE_FAIL:uint = 10;				// 获取网关失败
		public static const LOGIN_CON_SINA_FAIL:uint = 11;				// 连接新浪账号验证服务器失败
	}

}