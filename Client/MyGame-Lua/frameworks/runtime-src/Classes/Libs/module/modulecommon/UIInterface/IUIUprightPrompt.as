package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUIUprightPrompt  extends IUIBase
	{
		function showPrompt(str:String):void
		function set overCallback(fun:Function):void
	}
	
}