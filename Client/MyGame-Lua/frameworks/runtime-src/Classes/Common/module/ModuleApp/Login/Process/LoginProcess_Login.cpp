package app.login.process
{
	import app.login.uiheroselect.UIHeroSelectNew;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import login.LoginMgr;

	
	import flash.utils.ByteArray;
	import flash.net.SharedObject;
	import app.login.netmsg.loginmsg.stCreateCharUserCmd;
	import app.login.netmsg.loginmsg.stUserRequestLoginCmd;
	import network.WorldSocketEvent;
	
	
	/**
	 * ...
	 * @author ...
	 * 玩家上线流程
	 */
	public class LoginProcess_Login extends LoginProcessBase
	{
		public static const LOGINSERVER_STEP_NONE:int = 0;
		public static const LOGINSERVER_STEP_StartFirst:int = 1;
		public static const LOGINSERVER_STEP_StartSecond:int = 2;
		public static const LOGINSERVER_STEP_Sucess:int = 2;
		
		//private var m_loginServerStep:int;
		public function LoginProcess_Login()
		{
			super();
		
		}
		override public function begin():void 
		{
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_StartConnectLoginServer;
			//m_loginServerStep = LOGINSERVER_STEP_StartFirst;
			
			setIPAndPortOfLoginServer(m_context.m_config.m_ip, m_context.m_config.m_port);
			//setIPAndPortOfLoginServer("login.wdsg.wanwan.sina.com", 7001);
			connectToLoginServer();
		}
		override public function connectToLoginServer():void
		{			
			m_beginConnectToLoginServer = m_context.m_processManager.platformTime;
			m_context.m_LoginMgr.worldSocketMgr.addEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToLoginServer);
			m_context.m_LoginMgr.worldSocketMgr.addEventListener(WorldSocketEvent.WORLDIOERROR_EVENT, onConnectToLoginServerFailed);
			m_context.m_LoginMgr.worldSocketMgr.openSocket(m_ipToLoginServer, m_portToLoginServer);
			
			var str:String = "连接登陆服务器(" + m_ipToLoginServer + ": " + m_portToLoginServer + ")";
			m_context.addLog(str);
			m_context.m_LoginMgr.setLoginprocessDesc(str);
			
			str += " time=" + m_beginConnectToLoginServer;
			Logger.info(null, null, str);
			
			// m_gkcont.m_netISP.toggleISPID();
			//m_gkcont.m_netISP.connectNextIP = connectNextIP;
		}
		
		override protected function onConnectToLoginServer(e:WorldSocketEvent):void 
		{
			super.onConnectToLoginServer(e);
			m_context.m_LoginMgr.worldSocketMgr.removeEventListener(WorldSocketEvent.WORLDIOERROR_EVENT, onConnectToLoginServerFailed);
			//m_loginServerStep = LOGINSERVER_STEP_Sucess;
			m_context.m_LoginMgr.setIPAndPortOfLoginServer(m_ipToLoginServer, m_portToLoginServer);			
		}
		
		private function onConnectToLoginServerFailed(e:WorldSocketEvent):void
		{
			//if (m_loginServerStep == LOGINSERVER_STEP_StartFirst)
			//{
			//	m_loginServerStep == LOGINSERVER_STEP_StartSecond;
			//	setIPAndPortOfLoginServer(m_gkcont.m_context.m_config.m_ip2, m_gkcont.m_context.m_config.m_port2);
			//	connectToLoginServer();
			//}
			//else if (m_loginServerStep == LOGINSERVER_STEP_StartSecond)
			//{
			//	
			//}
			
			//m_gkcont.m_netISP.onConnectToLoginServerFailed();
		}
		
		public function connectNextIP(ip:String, port:uint):void
		{
			//m_loginServerStep == LOGINSERVER_STEP_StartSecond;
			//setIPAndPortOfLoginServer(m_gkcont.m_context.m_config.m_ip2, m_gkcont.m_context.m_config.m_port2);
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_StartConnectLoginServer;
			setIPAndPortOfLoginServer(ip, port);
			connectToLoginServer();
		}
		override protected function onConnectToGameServer(e:WorldSocketEvent):void
		{
			super.onConnectToGameServer(e);
			//m_gkcont.m_netISP.onConnectToLoginServer();
		}
		override public function sendUserInfoToLoginServer():void
		{
			if (m_context.m_platformMgr.byLoginplatform)
			{
				var sharObject:SharedObject = SharedObject.getLocal("stoplogin");
				if (sharObject.data.stoplogin != undefined)
				{
					return;
				}
			
				m_context.m_platformMgr.sendLoginInfo();
			}
			else
			{
				m_context.m_cryptoSys.bStartEncrypt = false;
				var send:stUserRequestLoginCmd = new stUserRequestLoginCmd();
				send.m_userID = m_loginData.m_userID;
				send.platformType = m_loginData.m_platform_Qianduan;
				send.zoneid = m_loginData.m_ZoneID_Qianduan;
				
				send.char_zoneid = m_loginData.m_ZoneID_Qianduan;
				send.char_platformType = m_loginData.m_platform_Qianduan;
				send.number = 0;
				m_context.sendMsg(send);				
			}
		}
		
		//登陆过程中，如果这个账号下还没有角色，则调用此函数
		public function loginGameServerResultNoUser(msg:ByteArray):void
		{
			//var send:stCreateCharUserCmd = new stCreateCharUserCmd();
			//send.career = 1;
			//send.sex = 1;
			//m_gkcont.m_context.sendMsg(send);
			
			// 加载角色选择
			m_context.m_fCreateHero = createHero;			
			m_context.m_binHeroSel = true;
			m_context.m_bFirstCreateAndEnter = true;
			m_context.m_bNewHero = true;
			//m_gkcont.m_firCreateHero = true;
			//m_gkcont.m_UIMgr.loadForm(UIFormID.UIHeroSelectNew);
			// 显示加载进度条
			m_context.progLoading.state = EntityCValue.PgHeroSel;
			m_context.progLoading.hide();
			/*m_context.progLoading.startLoading();*/
			
			var ui:UIHeroSelectNew = new UIHeroSelectNew();
			m_context.m_uiManagerSimple.addForm(ui);
			ui.show();
			//m_gkcont.m_UIMgr.loadHeroSel();
		}
		
		public function createHero(career:uint, sex:uint, minor:uint):void
		{
			m_context.m_fCreateHero = null;
			var send:stCreateCharUserCmd = new stCreateCharUserCmd();
			send.career = career;
			send.sex = sex;
			send.minor = minor;
			m_context.sendMsg(send);
		}
	}
}