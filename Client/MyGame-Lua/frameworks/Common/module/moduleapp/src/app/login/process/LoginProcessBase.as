package app.login.process 
{
	/**
	 * ...
	 * @author ...
	 */
	
	import com.pblabs.engine.debug.Logger;
	import com.util.DebugBox;
	import app.login.netmsg.loginmsg.stUserVerifyVerCmd;
	import common.Context;
	import login.LoginMgr;
	
	import network.SocketT;
	
	import flash.utils.ByteArray;
	
	import app.login.netmsg.loginmsg.stPasswdLogonUserCmd;
	import app.login.netmsg.loginmsg.stServerReturnLoginFailedCmd;
	import app.login.netmsg.loginmsg.stServerReturnLoginSuccessCmd;
	

	import login.LoginData;
	
	import network.WorldSocketEvent;
	import flash.utils.Endian;
	
	//import modulecommon.ui.UIFormID;
	//import com.pblabs.engine.entity.EntityCValue;
	public class LoginProcessBase 
	{		
		protected var m_context:Context;
		protected var m_loginData:LoginData;
		
		//下面4个时间用于记录登陆时间，起调试作用
		protected var m_beginConnectToLoginServer:Number;
		protected var m_EndConnectToLoginServer:Number;
		protected var m_beginConnectToGameServer:Number;
		protected var m_EndConnectToGameServer:Number;
		
			
		protected var m_ipToLoginServer:String;
		protected var m_portToLoginServer:int;
		protected var m_loginTempID:uint;
		public function LoginProcessBase() 
		{
			
		}
		public function set cont(cont:Context):void
		{			
			m_context = cont;
			m_loginData = m_context.m_LoginData;
		}
		
		public function setIPAndPortOfLoginServer(ip:String, port:int):void
		{
			m_ipToLoginServer = ip;
			m_portToLoginServer = port;
		}
		
		public function dispose():void
		{
			m_context.m_LoginMgr.removeEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToLoginServer);
		}
		
		public function begin():void
		{
			setIPAndPortOfLoginServer(m_context.m_LoginMgr.ipToLoginServer, m_context.m_LoginMgr.portToLoginServer);
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_StartConnectLoginServer;
			connectToLoginServer();
		}
		
		public function connectToLoginServer():void
		{
			m_beginConnectToLoginServer = m_context.m_processManager.platformTime;
			m_context.m_LoginMgr.worldSocketMgr.addEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToLoginServer);			
			m_context.m_LoginMgr.worldSocketMgr.openSocket(m_ipToLoginServer, m_portToLoginServer);
			
			var str:String = "连接登陆服务器(" + m_ipToLoginServer + ": " + m_portToLoginServer + ")";
			m_context.addLog(str);
			str += " time=" + m_beginConnectToLoginServer;
			Logger.info(null, null, str);
			m_context.m_LoginMgr.setLoginprocessDesc(str);
		}
		
		protected function onConnectToLoginServer(e:WorldSocketEvent):void
		{
			if (m_context.m_LoginMgr.m_connectStep != LoginMgr.STEP_StartConnectLoginServer)
			{
				return;
			}
			var soc:SocketT = e.m_worldSocket.Socket;
			if (soc.ip != m_ipToLoginServer || soc.port != m_portToLoginServer)
			{
				return;
			}
			m_EndConnectToLoginServer = m_context.m_processManager.platformTime;
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_ConnectedLoginServer;
			
			m_context.sceneSocket = e.worldSocket;
			
			var str:String = "连接登陆服务器成功，用时:" + (m_EndConnectToLoginServer-m_beginConnectToLoginServer).toString() + "毫秒";
			m_context.m_LoginMgr.worldSocketMgr.removeEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToLoginServer);
			m_context.addLog(str);
			m_context.m_LoginMgr.setLoginprocessDesc("连接登陆服务器成功");
			m_context.m_LoginMgr.removeEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToLoginServer);
			str += " time=" + m_EndConnectToLoginServer;
			Logger.info(null, null, str);
			//var sendVersion:stUserVerifyVerCmd = new stUserVerifyVerCmd();
			//m_gkcont.sendMsg(sendVersion);
			sendUserInfoToLoginServer();
		}
		
		public function process_stReturnUserVerifyVerCmd():void
		{
			//sendUserInfoToLoginServer();
		}		
		
		public function sendUserInfoToLoginServer():void
		{
			
		}
		
		//登陆LoginServer失败后，调用此函数
		//给出弹框提示
		public function loginFail(msg:ByteArray):void
		{
			var rev:stServerReturnLoginFailedCmd = new stServerReturnLoginFailedCmd();
			rev.deserialize(msg);
			var strPrompt:String;
			switch(rev.byReturnCode)
			{
				case stServerReturnLoginFailedCmd.LOGIN_RETURN_UNKNOWN:
					{
						strPrompt = "未知错误";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_RETURN_GATEWAYNOTAVAILABLE:
					{
						strPrompt = "网关服务器未开";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_RETURN_USERMAX:
					{
						strPrompt = "角色已满";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_RETURN_USERDATANOEXIST:
					{
						strPrompt = "角色档案不存在";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_RETURN_TIMEOUT:
					{
						strPrompt = "连接超时";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_TICKET_TIMEOUT:
					{
						strPrompt = "票据过期";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_TICKET_NOT_EXIST:
					{
						strPrompt = "票据不存在";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_SERVICE_ERROR:
					{
						strPrompt = "游戏标识错误";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_PARAM_ERROR:
					{
						strPrompt = "验证参数错误";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_INNER_ERROR:
					{
						strPrompt = "服务器内部错误";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_GET_GATE_FAIL:
					{
						strPrompt = "获取网关失败";
						break;
					}
				case stServerReturnLoginFailedCmd.LOGIN_CON_SINA_FAIL:
					{
						strPrompt = "连接新浪账号验证服务器失败，请按F5刷新网页！";
						break;
					}
			}
			DebugBox.forceInfo(strPrompt);		
			
			/*if (rev.byReturnCode >= stServerReturnLoginFailedCmd.LOGIN_TICKET_TIMEOUT && rev.byReturnCode <= stServerReturnLoginFailedCmd.LOGIN_PARAM_ERROR)
			{
				var url:URLRequest = new URLRequest(m_gkcont.m_platformMgr.domainURL);
				navigateToURL(url,"_top");
			}*/
		}
		
		//登陆LoginServer成功后，调用此函数
		public function connectToGameServer(msg:ByteArray):void
		{						
			m_context.addLog("关闭与登录服务器的连接");
			m_context.m_LoginMgr.worldSocketMgr.closeSocket(m_ipToLoginServer, m_portToLoginServer, true, false);
			m_context.m_sceneSocket = null;
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_StartConnectGameServer;
			//m_gkcont.m_LoginMgr.closeCurSocket();
			var rev:stServerReturnLoginSuccessCmd = new stServerReturnLoginSuccessCmd();
			rev.deserialize(msg);
			
			// 保存 key
			m_context.m_cryptoSys.key = rev.key;
			//m_gkcont.m_context.m_cryptoSys.decrypt(rev.buff);
			
			//var bt:ByteArray = new ByteArray();
			//bt.writeMultiByte("");
			/*
			var bt:ByteArray = new ByteArray();
			bt.endian = Endian.LITTLE_ENDIAN;
			bt.writeMultiByte("abcdefgh", "utf-8");
			m_gkcont.m_context.m_cryptoSys.encrypt(bt);
			bt.position = 0;
			rev.buff.position = 0;
			var idx:uint = 0;
			var a:int = 0;
			var b:int = 0;
			while(idx < 8)
			{
				a = bt.readUnsignedByte();
				b = rev.buff.readUnsignedByte();
				
				if(a != b)
				{
					trace("error");
				}
				++idx;
			}
			
			m_gkcont.m_context.m_cryptoSys.decrypt(rev.buff);
			rev.buff.position = 0;
			var str:String = rev.buff.readMultiByte(rev.buff.length, "utf-8");
			*/
			
			m_loginData.m_accid = rev.accid;
			m_loginData.m_userID = rev.m_userID;
			m_loginTempID = rev.loginTempID;		
			
			m_context.m_LoginMgr.setIPAndPortOfGameServer(rev.pstrIP, rev.wdPort);
			m_beginConnectToGameServer = m_context.m_processManager.platformTime;
			m_context.m_LoginMgr.worldSocketMgr.addEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToGameServer);
			m_context.m_LoginMgr.worldSocketMgr.openSocket(rev.pstrIP, rev.wdPort);
			
			var str:String = "连接网关服务器(" + m_context.m_LoginMgr.selfIP + " -> " + rev.pstrIP + ":" + rev.wdPort + ")" + "uid=" + m_loginData.m_userID.content;		
			m_context.addLog(str);
			
			str += " time=" + m_beginConnectToGameServer;
			Logger.info(null, null, str);
			m_context.m_LoginMgr.setLoginprocessDesc(str);
		}
		
		protected function onConnectToGameServer(e:WorldSocketEvent):void
		{
			m_context.m_LoginMgr.m_inProcessOfKuafuLogin = false;
			m_context.m_LoginMgr.m_connectStep = LoginMgr.STEP_ConnectedGameServer;
			m_context.sceneSocket = e.worldSocket;
			
			m_EndConnectToGameServer = m_context.m_processManager.platformTime;
			var str:String = "连接网关服务器成功，用时:" + (m_EndConnectToGameServer - m_beginConnectToGameServer).toString() + "毫秒";
			m_context.addLog(str);
			m_context.m_LoginMgr.setLoginprocessDesc("连接网关服务器成功");			
			m_context.m_LoginMgr.worldSocketMgr.removeEventListener(WorldSocketEvent.WPRLDOPENED_EVENT, onConnectToGameServer);	
			
			str += " time=" + m_EndConnectToGameServer;
			Logger.info(null, null, str);
			
			sendUserInfoToGameServer();
		}
		
		public function sendUserInfoToGameServer():void
		{
			m_context.m_cryptoSys.bStartEncrypt = false;
			var send:stPasswdLogonUserCmd = new stPasswdLogonUserCmd();
			send.accid = m_loginData.m_accid;
			send.loginTempID = m_loginTempID;
			m_context.sendMsg(send);
			m_context.m_cryptoSys.bStartEncrypt = true;		// 消息是否开始加密，发送这个消息后就开始加密
		}
		
		//下面
		public function loginGameServerResult(msg:ByteArray):void
		{
			//var rev:stReturnUserRegSceneCmd = new stReturnUserRegSceneCmd();
			//rev.deserialize(msg);
		}
		
		public function getTimeLog():String
		{			
			return "(" + m_beginConnectToLoginServer + ", " + m_EndConnectToLoginServer + ", " + m_beginConnectToGameServer + ", " + m_EndConnectToGameServer + ")";
		}
		
		
	}

}