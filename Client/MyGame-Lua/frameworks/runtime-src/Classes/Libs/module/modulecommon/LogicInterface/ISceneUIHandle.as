package modulecommon.logicinterface
{
	import flash.events.MouseEvent;
	/**
	 * @brief 场景 UI 处理
	 */
	public interface ISceneUIHandle
	{
		// ret 返回的点击的 UI Player 的列表
		function onClick(evt:MouseEvent, ret:Array):void;
		
		function onMouseEnter(evt:MouseEvent, ret:Array):void;
		function onMouseLeave(evt:MouseEvent):void;
	}
}