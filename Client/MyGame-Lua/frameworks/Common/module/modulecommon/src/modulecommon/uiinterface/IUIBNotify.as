package modulecommon.uiinterface
{
	import flash.utils.ByteArray;

	// 战报通知
	public interface IUIBNotify extends IUIBase
	{
		function psretDetailRobInfoUserCmd(msg:ByteArray):void;
	}
}