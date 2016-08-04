package network 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.util.DebugBox;
	import common.net.endata.EnNet;
	//import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.events.Event;
	//import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.errors.IOError;
	//import flash.utils.Endian;
	
	import com.pblabs.engine.debug.Logger;
	import common.crypto.CryptoSys;
	
	public class SocketT
	{
		/**
		 * 
		 * */
		protected var m_socket:Socket = null;
		protected var m_socketHandle:ISocketHandler;
		protected var m_ip:String;	// 保存 IP 地址 
		protected var m_port:int;	// 保存端口 
		protected var m_bclosestate:Boolean;	// 是否正在关闭状态    
		
		/**
		 * 
		 * */
		public function SocketT(socketHandle:ISocketHandler) 
		{
			init();
			m_socketHandle = socketHandle;
		}
		
		public function set cryptoSys(value:CryptoSys):void
		{
			
		}
		
		/**
		 * 
		 * */
		public function get getSocketT():Socket
		{
			return m_socket;
		}
		
		/**
		 * 
		 * */
		private function init():void
		{
			if (m_socket)
			{
				try
				{
					m_socket.close();
					m_socket = null;
				}
				catch (error:IOError)
				{
					
				}
			}
		}
		
		/**
		 * 
		 * */
		public function openSocket(ip:String, port:int):void
		{
			m_ip = ip;
			m_port = port;
			
			m_socket = new Socket();
			//m_socket.timeout = 5000;
			//m_socket.endian = Endian.LITTLE_ENDIAN;
			m_socket.endian = EnNet.DATAENDIAN;
			
			m_socket.addEventListener(Event.CONNECT, onConnect);
			m_socket.addEventListener(Event.CLOSE, onClose);
			m_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onsecurityErrorHandler);
			m_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			m_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			
			m_socket.connect(ip, port);
			
			Logger.info(this, "openSocket", "connecting ip= " + ip + " port=" + port.toString());
		}
		
		/**
		 * @brief socket 错误处理  
		 * */
		public function onIOError(e:IOErrorEvent):void 
		{
			
			var str:String = "onIOError--socket Error";
			Logger.info(this, "onIOError", str);
			DebugBox.addLog(str);			
		}
		
		/**
		 * 
		 * @param	event
		 */
		private function onsecurityErrorHandler(event:SecurityErrorEvent):void 
		{
			m_socketHandle.OnIOError(this);
			var str:String = "onsecurityErrorHandler--securityErrorHandler" + event.text;
			Logger.info(null, null, str);
			DebugBox.addLog(str);
		}
		
		/**
		 * 
		 * */
		public function onConnect(event:Event):void
		{
			Logger.info(this, "onConnect", "socket Connected");
			DebugBox.addLog("socket Connected");
			m_socketHandle.OnSocketOpenned(this);			
			
		}
		
		/**
		 * @brief 这个是 socket 自己断开 
		 * */
		public function onClose(event:Event):void
		{
			if (m_socket)
			{
				m_socket.close();
				
				// 断开的时候一定要关闭，否则关闭socket后，让然会收到某些消息 
				m_socket.removeEventListener(Event.CONNECT, onConnect);
				m_socket.removeEventListener(Event.CLOSE, onClose);
				m_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onsecurityErrorHandler);
				m_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				m_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			}
			
			var str:String = "socket onClosed(" + " port=" + m_ip + " port=" + m_port.toString() + ")";
			DebugBox.addLog(str);
			Logger.info(this, "onClose", str);
			
			// 移除 socket ，不要让上层再调用 close 这个函数了      
			m_socketHandle.closeSocket(m_ip, m_port, false);
			
			m_socket = null;
			m_socketHandle = null;
			
		}

		// 这个是上层主动断开链接   
		public function close():void
		{
			var strLog:String = "SocketT::close ";
			if (m_socket)
			{
				strLog += "m_socket 对象存在; "
				if (m_socket.connected)
				{
					strLog += "m_socket.connected==true; "
					try
					{
						m_socket.close();
						strLog += "exec close; "
					}
					catch (e:Error)
					{
						strLog += e.errorID+e.message;
					}
				}
				
				// 断开的时候一定要关闭，否则关闭socket后，让然会收到某些消息     
				m_socket.removeEventListener(Event.CONNECT, onConnect);
				m_socket.removeEventListener(Event.CLOSE, onClose);
				m_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onsecurityErrorHandler);
				m_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				m_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			}
			
			m_socket = null;
			m_socketHandle = null;
			DebugBox.addLog(strLog);
			Logger.info(this, "close", strLog);
		}
		/**
		 * 
		 * */
		protected function onSocketData(event:ProgressEvent):void
		{
			//Logger.info(this, "onSocketData", "received socket Data");
		}
		
		/**
		 * 
		 * */
		protected function set setSocket(socket:Socket):void
		{
			m_socket = socket;
		}
		
		public function get ip():String 
		{
			return m_ip;
		}
		
		public function set ip(value:String):void 
		{
			m_ip = value;
		}
		
		public function get port():int 
		{
			return m_port;
		}
		
		public function set port(value:int):void 
		{
			m_port = value;
		}
		
		/**
		 * 
		 * */
		public function SendData(sendData:ByteArray):void
		{
			//Logger.info(this, "SendData", "send socket Data");
			m_socket.writeBytes(sendData, 0, sendData.length);
			m_socket.flush();
		}

		/**
		 * 
		 * */
		public function GetMsg():ByteArray
		{
			return null;
		}
		
		public function get bclosestate():Boolean 
		{
			return m_bclosestate;
		}
		
		public function set bclosestate(value:Boolean):void 
		{
			m_bclosestate = value;
		}
	}
}