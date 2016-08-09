package  net
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IGameNetHandle  extends INetHandle
	{
		function cacheMsg():void;
		function unCacheMsg():void;
		function simulationMsg(msg:ByteArray, param:uint):void
	}
}