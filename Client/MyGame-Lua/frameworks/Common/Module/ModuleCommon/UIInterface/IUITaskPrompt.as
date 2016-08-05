package modulecommon.uiinterface 
{
	/**
	 * ...
	 * @author ...
	 */
	public interface IUITaskPrompt extends IUIBase
	{
		function updatePrompt():void;
		function updateLeftCountsAddTimes(id:int, time:int, count:int):void;
	}
	
}