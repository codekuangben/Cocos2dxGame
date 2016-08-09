package net
{
	import flash.utils.ByteArray;
	/**
	 * @brief 网络处理接口，切模块同时切网络       
	 */
	public interface INetHandle 
	{
		function handleMsg(msg:ByteArray, cmd:uint = 0, param:uint = 0):void;
		function destroy():void;
	}
}