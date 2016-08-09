package network 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.events.Event;
	import flash.utils.ByteArray;
	import network.ISocketHandler;
	
	public class StreamSocket extends SocketT
	{
		/**
		 * @param m_shutdown 是否关闭 socket 
		 * @param m_bConnecting socket 是否建立链接  
		 * */
		private var m_shutdown:Boolean;
		private var m_bConnecting:Boolean;
		
		/**
		 * 
		 * */
		public function StreamSocket(socketHandle:ISocketHandler) 
		{
			super(socketHandle);
			init();
		}
		
		/**
		 * 
		 * */
		private function init():void 
		{
			m_bConnecting = false;
			m_shutdown = true;
			m_bclosestate = false;
		}
		
		/**
		 * 
		 * */
		override public function GetMsg():ByteArray
		{
			return null;
		}
		
		// 这个是 socket 自己断开 
		override public function onClose(event:Event):void
		{
			// 说明当前 socket 正在由于对方主动断开而处于销毁状态 
			m_bclosestate = true;
			// 先关闭，然后再设置下面的状态，保证 SocketHandler.closeSocket 中 SocketEvent.CLOSED_EVENT 这个消息分发出去  
			super.onClose(event);
			// 先设置断开连接状态  
			m_bConnecting = false; 
			// 然后再设置关闭状态 
			m_shutdown = true;
		}
		
		// 这个是上层主动断开链接   
		override public function close():void
		{
			// 自己主动断开就不用设置 m_bclosestate = true 这个状态了 
			// 先关闭，然后再设置下面的状态 
			super.close();
			
			m_bConnecting = false; 
			m_shutdown = true;
		}
		
		override public function onConnect(event:Event):void
		{
			m_bConnecting = true;
			m_shutdown = false;
			
			super.onConnect(event);
		}
		
		/**
		 * 
		 * */
		public function get IsConnect():Boolean
		{
			return m_bConnecting;
		}
		
		/**
		 * 
		 * */
		public function get IsShutdown():Boolean
		{
			return m_shutdown;
		}
	}
}