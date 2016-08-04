package modulecommon.uiinterface 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.tongquetai.DancingWuNv;
	public interface IUITongQueWuHui extends IUIBase
	{
		function addDancing(dancer:DancingWuNv):void
		function removeDancing(dancer:DancingWuNv):void
		function becomeOver(dancer:DancingWuNv):void
		function processMsg(msg:ByteArray, param:uint):void
		function swichToMyPanel():void
		function updataTime(pos:int):void
		function showChat(pos:int, str:String):void
		function updateHaogan():void
	}

}