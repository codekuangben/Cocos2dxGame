package network 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		/**
		 * 
		 * */
		public static const OPENED_EVENT:String = "OPENED_EVENT";
		public static const CLOSED_EVENT:String = "CLOSED_EVENT";
		public static const IOERROR_EVENT:String = "IOError_EVENT";
		public var m_Socket:SocketT;
		 
		/**
		 * 
		 * */
		public function SocketEvent(type:String, socket:SocketT, bubles:Boolean = false, cancelable:Boolean = false ) 
		{
			m_Socket = socket;
			super(type, bubles, cancelable);
		}
		
		/**
		 * 
		 * */
		public function get getSocket():SocketT
		{
			return m_Socket;
		}
		
		/**
		 * 
		 * */
		public function set setSocket(socket:SocketT):void
		{
			m_Socket = socket;
		}
	}
}