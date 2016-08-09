package modulecommon.uiinterface
{
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIBase 
	{
		function set gkcontext(cnt:GkContext):void;
		function exit():void;
		function show():void;
		function isVisible():Boolean
	}
}