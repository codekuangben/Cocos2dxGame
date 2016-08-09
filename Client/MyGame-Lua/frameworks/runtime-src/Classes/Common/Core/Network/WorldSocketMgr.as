package network 
{
	/**
	 * @brief 场景 socket 管理器 
	 */
	import com.util.DebugBox;
	import common.net.endata.EnNet;
	import common.net.msg.basemsg.t_NullCmd;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	//import flash.utils.Endian;
	import com.pblabs.engine.debug.Logger;
	
	public class WorldSocketMgr extends EventDispatcher implements IWorldSocketMgr 
	{
		/**
		 * @brief 数据成员    
		 * */
		private var m_sockHandle:SocketHandler = new SocketHandler();
		//private var m_WrdSocket:IWorldHandler;
		private var m_WrdSocketDic:Dictionary;	
		// 发送数据的临时缓冲区，避免每一次都申请  
		private var m_SendData:ByteArray;
		/**
		 * 
		 * */
		public function WorldSocketMgr() 
		{
			m_WrdSocketDic = new Dictionary();
			init();
		}
		
		/**
		 * 
		 * */
		private function init():void
		{
			m_SendData = new ByteArray();
			//m_SendData.endian = Endian.LITTLE_ENDIAN;
			m_SendData.endian = EnNet.DATAENDIAN;
			
			m_sockHandle.addEventListener(SocketEvent.OPENED_EVENT, enterWorld);
			m_sockHandle.addEventListener(SocketEvent.CLOSED_EVENT, quitWorld);
			m_sockHandle.addEventListener(SocketEvent.IOERROR_EVENT, ioErrorWorld);
		}
		
		/**
		 * @brief socket 底层建立通过后才会进入 worldsocket 
		 * */
		public function enterWorld(event:SocketEvent):void
		{
			//m_WrdSocket = new WorldSocket(event.m_Socket, this);
			// 进入场景 
			var key:String = socketTools.socketKey(event.m_Socket.ip, event.m_Socket.port);
			if (m_WrdSocketDic[key])
			{
				delete m_WrdSocketDic[key];
				m_WrdSocketDic[key] = null;
			}
			m_WrdSocketDic[key] = new WorldSocket(event.m_Socket, this);
			
			// socket 链接成功通知场景    
			dispatchEvent(new WorldSocketEvent(WorldSocketEvent.WPRLDOPENED_EVENT, m_WrdSocketDic[key]));
		}
		
		/**
		 * @brief socket 关闭  
		 * */
		public function quitWorld(event:SocketEvent):void
		{
			// 离开场景    
			var str:String = "WorldSocketMgr quitWorld(" + " port=" + event.m_Socket.ip + " port=" + event.m_Socket.port.toString() + ")";
			DebugBox.addLog(str);
			
			var key:String = socketTools.socketKey(event.m_Socket.ip, event.m_Socket.port);
			if (m_WrdSocketDic[key])
			{
				str = "WorldSocketMgr quitWorld get";
				DebugBox.addLog(str);
				dispatchEvent(new WorldSocketEvent(WorldSocketEvent.WORLDCLOSED_EVENT, m_WrdSocketDic[key]));
				delete m_WrdSocketDic[key];
				m_WrdSocketDic[key] = null;
			}			
		}
		
		private function ioErrorWorld(event:SocketEvent):void
		{
			// 离开场景    			
			var ws:WorldSocket = new WorldSocket(event.m_Socket, this);
			dispatchEvent(new WorldSocketEvent(WorldSocketEvent.WORLDIOERROR_EVENT, ws));
		}
		
		/**
		 * 
		 * */
		/*public function set setWrdSocket(wrdSocket:IWorldHandler):void
		{
			//m_WrdSocket = wrdSocket;
			var key:String;

			key = socketTools.socketKey(wrdSocket.Socket.ip, wrdSocket.Socket.port);
			if (m_WrdSocketDic[key])
			{
				delete m_WrdSocketDic[key];
				m_WrdSocketDic[key] = null;
			}
			m_WrdSocketDic[key] = wrdSocket;
		}*/
		
		/**
		 * 
		 * */
		/*public function getWrdSocket(ip:String, port:int):IWorldHandler
		{
			//return m_WrdSocket;
			var key:String = socketTools.socketKey(ip, port);
			return m_WrdSocketDic[key];
		}*/
		
		/**
		 * 
		 * */
		public function getMsg(ip:String, port:int):ByteArray
		{
			//if (m_WrdSocket)
			//{
				//return m_WrdSocket.GetMsg();
			//}
			//
			//return null;
			
			var key:String = socketTools.socketKey(ip, port);
			if (m_WrdSocketDic[key])
			{
				return m_WrdSocketDic[key].GetMsg();
			}
			
			return null;
		}
		
		/**
		 * 
		 * */
		public function get msgByte():ByteArray
		{
			m_SendData.clear();
			return m_SendData;	
		}
		
		/**
		 * @brief 正常发送
		 * */
		public function sendData(msgbyte:ByteArray = null, ip:String = null, port:int = 0):void
		{
			//if (msgbyte != null)
			//{
				//m_WrdSocket.SenderData(msgbyte);
			//}
			//else
			//{
				//m_WrdSocket.SenderData(m_SendData);
			//}
			
			var key:String = socketTools.socketKey(ip, port);
			if (msgbyte != null)
			{
				m_WrdSocketDic[key].SendData(msgbyte);
			}
			else
			{
				m_WrdSocketDic[key].SendData(m_SendData);
			}
		}
		
		public function openSocket(ip:String, port:int):void
		{
			m_sockHandle.OpenSocket(ip, port);
		}
		
		public function closeSocket(ip:String, port:int, isclose:Boolean=true, bdispatch:Boolean=true):void
		{
			m_sockHandle.closeSocket(ip, port,isclose,bdispatch);
		}
		
		public function sendMsg(cmd:t_NullCmd, ip:String, port:int):void
		{
			cmd.serialize(m_SendData);
			sendData(m_SendData, ip, port);
			// 发送消息打印消息日志   
			Logger.info("", "", "Cmd: " + cmd.byCmd + ", Param: " + cmd.byParam);
		}
	}
}