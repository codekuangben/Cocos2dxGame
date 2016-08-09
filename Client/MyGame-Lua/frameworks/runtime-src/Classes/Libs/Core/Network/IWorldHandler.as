package network 
{
	/**
	 * ...
	 * @author ...
	 * @brief 上层 socket 套接口
	 */
	import common.net.msg.basemsg.t_NullCmd;
	import flash.utils.ByteArray;
	import common.crypto.CryptoSys;
	
	public interface IWorldHandler 
	{
		function SendData(sendData:ByteArray):void;		
		function GetMsg():ByteArray;
		
		function get Socket():SocketT;		
		function set Socket(value:SocketT):void;
		function sendMsg(cmd:t_NullCmd):void;
		function get bclosestate():Boolean;
		
		function get ip():String;
		function get port():int;
		function set cryptoSys(value:CryptoSys):void;
	}
}