package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import net.loginUserCmd.stLoginUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stUserVerifyVerCmd extends stLoginUserCmd
	{
		public var version:uint;
		
		override public function stUserVerifyVerCmd() 
		{
			super();
			byParam = EnNet.USER_VERIFY_VER_PARA;
			version = 20140730;
		}

		override public function serialize (byte:ByteArray) : void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(version);
		}
	}
}


/*const DWORD version = 20140730;
    /// 客户端连接登陆服务器
    const BYTE USER_VERIFY_VER_PARA = 1;
    struct stUserVerifyVerCmd  : public stLogonUserCmd
    {   
        stUserVerifyVerCmd()
        {   
            byParam = USER_VERIFY_VER_PARA;
            ver = version;
        }        
        DWORD ver;
    };       
	
	登陆阶段的消息流程
	1. 与登陆服务器连接成功后
		1.发送(C->S)stUserVerifyVerCmd;
		2.Server收到stUserVerifyVerCmd后，返回(S->C)stReturnUserVerifyVerCmd
		3.Client收到stReturnUserVerifyVerCmd后, 发送账号信息
			1)如果在内网，则发送stUserRequestLoginCmd
			2)如果在外网，则发送stPlatformUserRequestLoginCmd
		4.Server收到账号信息后，发送(S->C)stServerReturnLoginSuccessCmd
		5.Client收到stServerReturnLoginSuccessCmd后，断开与登陆服务器的连接，连接网关服务器
*/