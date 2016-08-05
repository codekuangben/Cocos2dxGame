package network 
{
	/**
	 * ...
	 * @author ...
	 * @brief TcpSocket 管理器 
	 */
	//import flash.events.Event;
	import com.util.DebugBox;
	import flash.events.EventDispatcher;
	//import flash.globalization.Collator;
	import flash.utils.Dictionary;
	
	public class SocketHandler extends EventDispatcher implements ISocketHandler
	{
		/**
		 * @brief 现在管理器存放 socket 列表，用数组不用字典，感觉不会太多 
		 * */
		//protected var m_sock:SocketT;
		protected var m_sockDic:Dictionary;
		 
		/**
		 * 
		 * */
		public function SocketHandler() 
		{
			m_sockDic = new Dictionary();
		}
		
		/**
		 * 
		 * */
		public function init():void
		{
			
		}
		
		/**
		 * @brief 主动打开一个新的连接，如果这个 IP 地址和端口在使用
		 * */
		public function OpenSocket(ip:String, port:int):void
		{
			//if (m_sock)
			//{
			//	m_sock.onClose(null);
			//} 
			//m_sock = new TcpSocket(this);
			//m_sock.openSocket(ip, port);
			// 改成字典，打开 socket 的时候  
			var key:String = socketTools.socketKey(ip, port);
			//if (m_sockDic[key])
			//{
			//	m_sockDic[key].close(null);				
				// 这里不删除会有问题 
			//	delete m_sockDic[key];
			//	m_sockDic[key] = null;
			//}
			// 关闭 socket，这里不删除会有问题，如果这个 socket 被动关闭，很有可能等到新的 IP 和端口正确连接后才收到上一次断开的信息   
			closeSocket(ip, port);
			
			m_sockDic[key] = new TcpSocket(this);
			m_sockDic[key].openSocket(ip, port);
		}
		
		/**
		 * @brief isclose 是否调用关闭socket函数，主动关闭socket  isclose设置成 true ，如果被动关闭的，设置成 false ，被动就是socket自己发送断开连接的，调用 onClose 这个函数，然后再调用到这个函数 
		 * @param bdispatch 是否
		 * */
		public function closeSocket(ip:String, port:int, isclose:Boolean = true, bdispatch:Boolean = true):void
		{
			//m_sock.onClose();			
			var key:String = socketTools.socketKey(ip, port);
			// 如果 socket 在连接就关闭，如果已经关闭就不用关闭了 
			if (m_sockDic[key])
			{
				var str:String = "SocketHandler closeSocket(" + " port=" + ip + " port=" + port.toString() + ")";
				DebugBox.addLog(str);
				
				// 如果socket还在连接就发送关闭，这个要放在关闭函数之前  
				if (bdispatch)
				{
					dispatchEvent(new SocketEvent(SocketEvent.CLOSED_EVENT, m_sockDic[key]));
				}
				
				if (isclose)
				{
					m_sockDic[key].close();
				}
				
				m_sockDic[key] = null;
				delete m_sockDic[key];				
			}			
		}
		
		/**
		 * 
		 * */
		public function OnSocketOpenned(socket:SocketT):void
		{
			dispatchEvent(new SocketEvent(SocketEvent.OPENED_EVENT, socket));
		}
		public function OnIOError(socket:SocketT):void
		{
			dispatchEvent(new SocketEvent(SocketEvent.IOERROR_EVENT, socket));
		}
	}
}