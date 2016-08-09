package modulecommon.uiinterface 
{
	/**
	 * ...
	 * @author ...
	 */
	public interface IUIArenaStarter extends IUIBase
	{
		function updateLeftTimes(time:uint):void;
		function get count():uint;
		function canTZ():Boolean;
	}
}