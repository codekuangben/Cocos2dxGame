package modulecommon.uiinterface 
{
	import modulecommon.scene.task.TaskItem;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIGmPlayerAttributes 
	{
		function setOtherPlayerLog(str:String):void
		function showTaskInfo(taskItem:TaskItem):void
	}
	
}