package game
{
	import common.Context;
	/**
	 * ...
	 * @author ...
	 */
	public interface IModuleBase 
	{		
		function set context(rh:Context):void;
		function set closeHandle(rh:Function):void;
		function init():void;
		function destroy():void;
	}
}