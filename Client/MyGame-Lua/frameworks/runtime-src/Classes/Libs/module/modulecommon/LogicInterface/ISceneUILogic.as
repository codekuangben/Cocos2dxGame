package modulecommon.logicinterface
{
	import flash.display.Sprite;
	
	/**
	 * @brief UI 中的玩家模型逻辑处理
	 */
	public interface ISceneUILogic
	{
		function addHandle(dispatch:Sprite, handle:ISceneUIHandle):void
		function removeHandle():void;
	}
}