package modulecommon.logicinterface
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public interface IVipTY 
	{
		function pspracticeVipTimeUserCmd(msg:ByteArray):void;
		function set binit(value:Boolean):void;
		function canEnableTY():Boolean;
		
		function clearDJS():void;
		function clearActiveIcon():void;
		function isDJSEnd():Boolean;
	}
}