package app.login.netmsg.loginmsg 
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	
	/**
	 * ...
	 * @author 
	 * DISCONNECT_UNKNOWN等常量定义在EntityCValue
	 */
	public class stServerReturnDisConnectCmd extends stLoginUserCmd 
	{	
		public var ret:int;
		public function stServerReturnDisConnectCmd() 
		{
			byParam = SERVER_RETURN_DISCONNECT;			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			ret = byte.readUnsignedByte();
		}
		
	}

}

/// 连接断开前返回的信息
   /*
	* enum{
        DISCONNECT_UNKNOWN = 0,   /// 未知错误
        DISCONNECT_TAKEOFF = 1,/// 被管理员强制下线
        DISCONNECT_HEART = 2,   /// 心跳包检测失败下线
        DISCONNECT_REPEAT = 3,   /// 重复登录
		DISCONNECT_OUTTIME = 4,   /// 连接网关超时
		DISCONNECT_MAPERROR = 5,   /// 场景地图错误
    };
	* const BYTE SERVER_RETURN_DISCONNECT = 13;
    struct stServerReturnDisConnectCmd : public stLogonUserCmd
    {
        stServerReturnDisConnectCmd()
        {
            byParam = SERVER_RETURN_DISCONNECT;
            ret = DISCONNECT_UNKNOWN;
        }
        BYTE ret;      /**< 返回的子参数 */
   // } ;*/