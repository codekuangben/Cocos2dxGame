package network 
{
	/**
	 * @brief 场景 socket 与场景之间通信的事件     
	 */
	import flash.events.Event;
	
	public class WorldSocketEvent extends Event
	{
		/**
		 * 
		 * */
		public static const WPRLDOPENED_EVENT:String = "WPRLDOPENED_EVENT";
		public static const WORLDCLOSED_EVENT:String = "WORLDCLOSED_EVENT";
		public static const WORLDIOERROR_EVENT:String = "WORLDIOERROR_EVENT";
		
		public var m_worldSocket:IWorldHandler;
		 
		/**
		 * 
		 * */
		public function WorldSocketEvent(type:String, socket:IWorldHandler, bubles:Boolean = false, cancelable:Boolean = false ) 
		{
			m_worldSocket = socket;
			super(type, bubles, cancelable);
		}
		
		/**
		 * 
		 * */
		public function get worldSocket():IWorldHandler
		{
			return m_worldSocket;
		}
		
		/**
		 * 
		 * */
		public function set worldSocket(socket:IWorldHandler):void
		{
			m_worldSocket = socket;
		}
	}
}