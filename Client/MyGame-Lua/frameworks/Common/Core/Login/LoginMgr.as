package login
{
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	import flash.utils.ByteArray;	

	import network.WorldSocketMgr;
	import network.WorldSocketEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LoginMgr extends EventDispatcher
	{
		public static const STEP_NONE:int = 0;
		public static const STEP_StartConnectLoginServer:int = 1;
		public static const STEP_ConnectedLoginServer:int = 2;
		public static const STEP_StartConnectGameServer:int = 3;
		public static const STEP_ConnectedGameServer:int = 4;
		
		
		private var m_context:Context;
		private var m_sockMgr:WorldSocketMgr;
		private var m_loginHandle:ILoginHandle;
		private var m_msgTick:ITickedObject;
		
		public var m_connectStep:int;
		public var m_inProcessOfKuafuLogin:Boolean;	//处于跨服登陆过程中
		
		protected var m_ipToLoginServer:String;
		protected var m_portToLoginServer:int;
		
		protected var m_ipToGameServer:String;
		protected var m_portToGameServer:int;
		
		protected var m_selfIP:String;
		
		//private var m_inConnectedToGameServer:Boolean; //true - 与游戏服务器正常连接状态
		
		public var m_receiveMapMsg:Boolean;	//登陆时收到了stMapDataUserCmd
		public var m_receivesynOnlineFinDataUserCmd:int = 0;
		private var m_loginprocessDesc:String;
		
		private var m_bCrossserverDataReady:Boolean;	//跨服
		public function LoginMgr(con:Context)
		{
			m_context = con;
			m_sockMgr = new WorldSocketMgr();			
			
			m_sockMgr.addEventListener(WorldSocketEvent.WORLDCLOSED_EVENT, onworldCloseEvent);
		}
		
		public function setIPAndPortOfLoginServer(ip:String, port:int):void
		{
			m_ipToLoginServer = ip;
			m_portToLoginServer = port;
		}
		
		public function setIPAndPortOfGameServer(ip:String, port:int):void
		{
			m_ipToGameServer = ip;
			m_portToGameServer = port;
		}
		
		public function begin(type:int):void
		{
			m_loginHandle.begin(type);
		}
		
		public function openSocket(ip:String, port:int):void
		{
			m_sockMgr.openSocket(ip, port);
		}		
		
		public function set msgTick(ito:ITickedObject):void
		{
			m_msgTick = ito;
		}		
		
		/*
		 *Socket被动关闭，调用此函数
		 * 主动关闭不会再调用此函数.
		 * 有2处主动关闭Socket:
			 * 1. 连接网关服务器前，主动断开跟登陆服务器的连接
			 * 2. 跨区时，会收到synLandZoneUserCmd。先主动断开跟网关服务器的连接，再连接登陆服务器
			在这样的机制下，ModuleAppRoot::onTick不会被递归调用。
		 */ 
		private function onworldCloseEvent(e:WorldSocketEvent):void
		{
			// 这里要判断 ip 和端口，判断具体连接   
			// 关闭 socket 的时候需要把所有的消息弹出来处理，这个放在一个缓冲队列比较好  
			
			m_context.addLog("LoginMgr::onworldCloseEvent  begin");
			if (m_context.m_sceneSocket != e.worldSocket)
			{
				return;
			}
			//当socket被动关闭，执行到这里时，可能还有消息未处理
			m_msgTick.onTick(0);
			m_context.m_sceneSocket = null;
			
			
			m_context.addLog("LoginMgr::onworldCloseEvent  m_sceneSocket=null；m_connectStep=" + m_connectStep + " inProcessOfKuafuLogin=" + m_inProcessOfKuafuLogin);
			
			if (m_inProcessOfKuafuLogin == false&& m_connectStep == STEP_ConnectedGameServer)
			{
				m_context.addLog("LoginMgr::onworldCloseEvent  2");
				if (m_context.m_gkcontext)
				{
					m_context.m_gkcontext.onNetWorkDropped(EntityCValue.DISCONNECT_CLIENT_DETECT);
				}
			}
		}
		
		public function set loginHandle(handle:ILoginHandle):void
		{
			m_loginHandle = handle;
		}
		
	
		public function setLoginprocessDesc(str:String):void
		{
			m_loginprocessDesc = str;
			
			m_context.progLoading.setText(m_loginprocessDesc);
			
		}
		
		public function get worldSocketMgr():WorldSocketMgr
		{
			return m_sockMgr;
		}
	
		public function get ipToLoginServer():String
		{
			return m_ipToLoginServer;
		}
		
		public function get portToLoginServer():int
		{
			return m_portToLoginServer;
		}
		
		public function get ipToGameServer():String
		{
			return m_ipToGameServer;
		}
		
		public function get portToGameServer():int
		{
			return m_portToGameServer;
		}
		
		public function setSelfIP(str:String):void
		{
			m_selfIP = str;			
		}
		
		public function get selfIP():String
		{
			return m_selfIP;
		}
		
				
		public function get bCrossserverDataReady():Boolean
		{
			return m_bCrossserverDataReady;
		}
		
		public function get sockMgr():WorldSocketMgr
		{
			return m_sockMgr;
		}
	}

}