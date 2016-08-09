package network 
{
	/**
	 * ...
	 * @author ...
	 */
	public interface ISocketHandler 
	{
		/**
		 * @brief socket 一旦打开成功 
		 * */		
		function OpenSocket(ip:String, port:int):void;
		function closeSocket(ip:String, port:int, closeSocket:Boolean = true, bdispatch:Boolean = true):void;
		function OnSocketOpenned(socket:SocketT):void;
		function OnIOError(socket:SocketT):void;
	}
}