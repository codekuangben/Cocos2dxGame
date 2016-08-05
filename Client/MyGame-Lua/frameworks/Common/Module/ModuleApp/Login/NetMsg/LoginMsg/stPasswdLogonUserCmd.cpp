package app.login.netmsg.loginmsg
{
	import flash.utils.ByteArray;
	import net.loginUserCmd.stLoginUserCmd;
	//import com.util.UtilTools;
	/**
	 * ...
	 * @author 
	 * /// 客户登陆网关服务器
	const BYTE PASSWD_LOGON_USERCMD_PARA = 6;
	struct stPasswdLogonUserCmd : public stLogonUserCmd
	{
		stPasswdLogonUserCmd()
		{
			byParam = PASSWD_LOGON_USERCMD_PARA;
		}

		DWORD loginTempID;
		DWORD accid;
	};
	 */
	public class stPasswdLogonUserCmd extends stLoginUserCmd
	{
		public var loginTempID:uint;
		public var accid:uint;
		
		public function stPasswdLogonUserCmd() 
		{
			super();
			byParam = PASSWD_LOGON_USERCMD_PARA;
		}
		
		override public function serialize (byte:ByteArray) : void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(loginTempID);
			byte.writeUnsignedInt(accid);
		}
	}
}