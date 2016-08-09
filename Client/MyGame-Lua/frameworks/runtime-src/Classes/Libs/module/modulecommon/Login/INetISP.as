package modulecommon.login 
{
	/**
	 * @brief 接口实现
	 */
	public interface INetISP 
	{
		function onConnectToLoginServerFailed():void;
		function onBtnClkConnectServer():void;
		function set connectNextIP(value:Function):void;
		function set ISPID(value:uint):void;
		function get ISPID():uint;
		function getUserStr():String;
		function toggleISPID():void;
		function addISPChangeEventDispatcher(cb:Function):void;
		function onConnectToLoginServer():void;
	}
}