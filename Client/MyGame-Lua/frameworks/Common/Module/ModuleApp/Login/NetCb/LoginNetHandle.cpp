package app.login.netcb
{
	//import adobe.utils.CustomActions;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import common.Context;
	import common.net.msg.basemsg.stNullUserCmd;
	import app.login.netmsg.loginmsg.stReturnReleaseVerCmd;
	import app.login.netmsg.loginmsg.stServerReturnDisConnectCmd;
	import app.login.netmsg.loginmsg.synLandZoneUserCmd;
	import app.login.process.LoginProcess_CrossZone;
	import app.login.process.LoginProcess_Login;

	import app.login.process.LoginProcessBase;

	import login.ILoginHandle;
	import net.INetHandle;
	
	//import common.net.msg.basemsg.t_NullCmd;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import app.login.netmsg.loginmsg.stReturnUserVerifyVerCmd;	
	import app.login.netmsg.loginmsg.stGameTimeTimerUserCmd;
	import login.LoginData;
	
	//import login.ModuleLoginRoot;
	import net.loginUserCmd.stLoginUserCmd;
	//import modulecommon.ui.UIFormID;
	import net.timemsg.stTimerUserCmd;
	/**
	 * ..
	 * 登陆有以下几种情况
	 * 1. 角色登陆游戏
	 * 2. 角色从自己的区登陆到其它区
	 * 3. 角色从其他区，到另一个其它区
	 * 4. 角色从其他区，回到自己的区
	 */
	public class LoginNetHandle implements INetHandle, ILoginHandle
	{
		// 函数注册   
		private var m_regfunc:Dictionary;
		
		private var m_loginType:int; //见LoginData.LOGINTYPE_Login定义
		private var m_processBase:LoginProcessBase;
		private var m_context:Context;
		public function LoginNetHandle(gk:Context)
		{
			m_regfunc = new Dictionary();
			
			m_regfunc[stLoginUserCmd.RETURN_USER_VERIFY_VER_PARA] = handleVerifyVer;
			m_regfunc[stLoginUserCmd.SERVER_RETURN_LOGIN_FAILED] = handleLoginFailed;
			m_regfunc[stLoginUserCmd.SERVER_RETURN_LOGIN_OK] = handleLoginSuccess;
			m_regfunc[stLoginUserCmd.RETURN_RELEASE_VER_PARA] = handleReturnReleaseVerCmd;
			
			m_regfunc[stLoginUserCmd.RETURN_NO_CHAR_USERCMD_PARA] = handleReturnNoCharUserCmd;
			m_regfunc[stLoginUserCmd.SYN_LAND_ZONE_PARA] = handle_synLandZoneUserCmd;
			m_regfunc[stLoginUserCmd.SERVER_RETURN_DISCONNECT] = handle_stServerReturnLoginFailedCmd;
			m_loginType = -1;		
			
			m_context = gk;
			
			m_context.m_LoginMgr.loginHandle = this;
		}
		
		public function destroy():void
		{
		
		}
		
		public function handleMsg(msg:ByteArray, cmd:uint = 0, param:uint = 0):void
		{
			
			if (stNullUserCmd.TIME_USERCMD == cmd && stTimerUserCmd.GAMETIME_TIMER_USERCMD_PARA == param)
			{
				handleGameTime(msg);
				return;
			}
			
			if (m_regfunc[param])
			{
				m_regfunc[param](msg);
			}
		}
		
		// 校验版本返回信息 
		public function handleVerifyVer(msg:ByteArray):void
		{
			var cmd:stReturnUserVerifyVerCmd = new stReturnUserVerifyVerCmd();
			cmd.deserialize(msg);
			m_context.m_LoginMgr.setSelfIP(cmd.m_ip);
			
			var str:String = "客户端IP" + cmd.m_ip
			m_context.addLog(str);
			Logger.info(null, null, str);
			m_processBase.process_stReturnUserVerifyVerCmd();
		}
		
		// 登录失败 
		public function handleLoginFailed(msg:ByteArray):void
		{
			m_processBase.loginFail(msg);
		}
		
		// 登录【登陆服务器】成功 
		public function handleLoginSuccess(msg:ByteArray):void
		{
			m_processBase.connectToGameServer(msg);	
		
		}
		
		// 这个暂时是进入场景的第一个消息   
		public function handleGameTime(msg:ByteArray):void
		{
			Logger.info(null, null, "成功登录网关");
			var cmd:stGameTimeTimerUserCmd = new stGameTimeTimerUserCmd();
			cmd.deserialize(msg);
			m_context.m_timeMgr.setTime(cmd.qwGameTime, cmd.openservertime);
		
			// 卸载登录模块
			//m_context.m_unloadLoginFunc();
		}
		
		public function handleRegSceneResult(msg:ByteArray):void
		{
			m_processBase.loginGameServerResult(msg);
			// 卸载登录模块
			//m_context.m_unloadLoginFunc();
		}
		
		public function handleReturnNoCharUserCmd(msg:ByteArray):void
		{
			(m_processBase as LoginProcess_Login).loginGameServerResultNoUser(msg);
		}
		
		public function handleReturnReleaseVerCmd(msg:ByteArray):void
		{
			var rev:stReturnReleaseVerCmd = new stReturnReleaseVerCmd();
			rev.deserialize(msg);
			m_context.m_config.m_versionForOutNet = true;		
			m_context.addLog("收到stReturnReleaseVerCmd m_versionForOutNet = true");
		}
		
		public function handle_synLandZoneUserCmd(msg:ByteArray):void
		{
			m_context.addLog("收到synLandZoneUserCmd");
			m_context.m_cryptoSys.bStartEncrypt = false;
			m_context.m_LoginMgr.m_inProcessOfKuafuLogin = true;
			
			m_context.addLog("关闭与game服务器的连接");
			m_context.m_LoginMgr.worldSocketMgr.closeSocket(m_context.m_LoginMgr.ipToGameServer, m_context.m_LoginMgr.portToGameServer, true, false);
			m_context.m_sceneSocket = null;
			
			var rev:synLandZoneUserCmd = new synLandZoneUserCmd();
			rev.deserialize(msg);
			
			m_loginType = LoginData.LOGINTYPE_CrossZone;
			if (m_processBase)
			{
				m_processBase.dispose();
				m_processBase = null;
			}
			m_processBase = new LoginProcess_CrossZone();
			m_processBase.cont = m_context;
			(m_processBase as LoginProcess_CrossZone).setParam(rev.zoneid_houduan, rev.plattype, rev.number);
			m_processBase.begin();			
		}
		public function handle_stServerReturnLoginFailedCmd(msg:ByteArray):void
		{
			var rev:stServerReturnDisConnectCmd = new stServerReturnDisConnectCmd();
			rev.deserialize(msg);
			var strLog:String;
			if (rev.ret == EntityCValue.DISCONNECT_OUTTIME)
			{
				strLog = "连接网关超时";
				if (m_processBase)
				{
					strLog += m_processBase.getTimeLog();
				}
				DebugBox.forceInfo(strLog);				
			}
			else if (rev.ret == EntityCValue.DISCONNECT_MAPERROR)
			{
				DebugBox.forceInfo("场景地图错误");
			}
			else if (rev.ret == EntityCValue.DISCONNECT_DBERROR)
			{
				DebugBox.forceInfo("数据库错误");
			}
			else if (rev.ret == EntityCValue.DISCONNECT_MAINTAIN)
			{
				DebugBox.forceInfo("服务器正在维护，请稍后登陆");
			}
			else if (rev.ret == EntityCValue.DISCONNECT_INZHANCHANG)
			{
				m_context.m_LoginMgr.setLoginprocessDesc("已在战场中登陆");
				DebugBox.forceInfo("登陆出现问题，请刷新页面重新进入");				
			}
			else
			{				
				strLog = "掉线了，stServerReturnDisConnectCmd.ret=" + rev.ret;
				m_context.addLog(strLog);
				if (m_context.m_gkcontext)
				{
					m_context.m_gkcontext.onNetWorkDropped(rev.ret);
				}
				else
				{
					DebugBox.forceInfo(strLog);
				}
			}
		}
		
		public function begin(type:int):void
		{
			if (m_loginType != type)
			{				
				m_loginType = type;
				var processClass:Class;
				switch (m_loginType)
				{
					case LoginData.LOGINTYPE_Login: 
						processClass = LoginProcess_Login;
						break;					
				}
				if (m_processBase)
				{
					m_processBase.dispose();
					m_processBase = null;
				}
				m_processBase = new processClass();
				m_processBase.cont = m_context;
			}
			m_processBase.begin();
		}
	}
}