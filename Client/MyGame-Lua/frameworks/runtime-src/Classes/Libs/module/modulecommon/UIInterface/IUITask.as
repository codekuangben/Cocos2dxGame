package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUITask  extends IUIBase
	{
		function onAddTask(id:uint):void
		function onUpdateVar(id:uint):void
		function onDeleteTask(id:uint):void
	}
	
}