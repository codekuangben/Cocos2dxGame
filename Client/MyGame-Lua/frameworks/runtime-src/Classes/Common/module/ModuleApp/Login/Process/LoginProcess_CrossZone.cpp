package app.login.process 
{
	/**
	 * ...
	 * @author 
	 */
	import app.login.netmsg.loginmsg.stUserRequestLoginCmd;
	public class LoginProcess_CrossZone extends LoginProcessBase 
	{		
		protected var m_zoneid_houduan:uint;
		protected var m_platform:uint;
		protected var m_number:uint;
		public function LoginProcess_CrossZone() 
		{
			super();			
		}
		
		public function setParam(zoneid_houduan:uint, platform:uint, number:uint):void
		{
			m_zoneid_houduan = zoneid_houduan;
			m_platform = platform;
			m_number = number;
		}
		
		override public function sendUserInfoToLoginServer():void
		{
			m_context.m_cryptoSys.bStartEncrypt = false;
			var send:stUserRequestLoginCmd = new stUserRequestLoginCmd();
			
			send.platformType = m_platform;
			send.zoneid = m_zoneid_houduan;
			send.number = m_number;
			
			send.char_zoneid = m_loginData.m_ZoneID_Qianduan;
			send.char_platformType = m_loginData.m_platform_Qianduan;
			
			
			send.m_userID = m_loginData.m_userID;
			m_context.sendMsg(send);
		}
		
	}

}