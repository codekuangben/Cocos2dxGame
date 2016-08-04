package network 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * @brief socket 管理器的基类 
	 */
	public interface IWorldSocketMgr 
	{
		function openSocket(ip:String, port:int):void;
		function getMsg(ip:String, port:int):ByteArray;
		
		function sendData(msgbyte:ByteArray = null, ip:String = "", port:int = 0):void;
		function get msgByte():ByteArray;
		function closeSocket(ip:String, port:int, isclose:Boolean=true, bdispatch:Boolean=true):void;
	}
}