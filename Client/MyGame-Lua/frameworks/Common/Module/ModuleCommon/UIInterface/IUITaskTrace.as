package modulecommon.uiinterface 
{
	import com.bit101.components.controlList.ControlListVHeight;
	import flash.geom.Point;
	//import flash.geom.Point;
	import modulecommon.scene.task.TaskItem;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUITaskTrace extends IUIBase
	{
		function addTask(id:uint):void;
		function updateTask(id:uint):void;
		function deleteTask(id:uint):void
		function showNewHand(taskid:uint, desc:String = ""):void
		function execTaskGoal(taskItem:TaskItem):void
		function gotoFunc(destX:int, destY:int, mapID:int, npcID:int):void
		function setYugao(id:int, bOpen:Boolean, bShow:Boolean):void
		function getList():ControlListVHeight;	//
		function getTaskBtnPos():Point;
		function updateXunhuanTaskIndex():void
	}
	
}