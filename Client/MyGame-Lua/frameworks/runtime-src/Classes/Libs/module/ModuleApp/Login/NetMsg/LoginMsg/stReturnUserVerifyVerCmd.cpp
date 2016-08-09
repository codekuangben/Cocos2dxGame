package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	import com.util.UtilTools;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stReturnUserVerifyVerCmd extends stLoginUserCmd
	{
		public var m_ip:String;
		public function stReturnUserVerifyVerCmd()
		{
			super();
			byParam = RETURN_USER_VERIFY_VER_PARA;
		}
		
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			m_ip = UtilTools.readStr(byte, EnNet.MAX_IP_LENGTH);
		}
	}
}

/// 返回客户端登陆
    /*const BYTE RETURN_USER_VERIFY_VER_PARA = 2;
    struct stReturnUserVerifyVerCmd  : public stLogonUserCmd
    {   
        stReturnUserVerifyVerCmd()
        {   
            byParam = RETURN_USER_VERIFY_VER_PARA;
            bzero(ip, MAX_IP_LENGTH);
        }   
        char ip[MAX_IP_LENGTH];
    };*/