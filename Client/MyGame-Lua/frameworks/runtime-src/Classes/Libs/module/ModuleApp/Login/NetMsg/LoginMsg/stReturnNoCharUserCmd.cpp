package  app.login.netmsg.loginmsg
{
	import login.netmsg.loginmsg.stLogonUserCmd;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 
	 * // 客户登陆网关服务器返回没有角色(职业)
	const BYTE RETURN_NO_CHAR_USERCMD_PARA = 7;
	struct stReturnNoCharUserCmd : public stLogonUserCmd
	{
		stReturnNoCharUserCmd()
		{
			byParam = RETURN_NO_CHAR_USERCMD_PARA;
		}
	};
	 */
	public class stReturnNoCharUserCmd extends stLogonUserCmd 
	{
		
		public function stReturnNoCharUserCmd() 
		{
			byParam = EnNet.RETURN_NO_CHAR_USERCMD_PARA;
		}		
	}

}