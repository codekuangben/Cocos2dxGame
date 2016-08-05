package modulecommon.uiinterface
{
	import flash.utils.ByteArray;

	public interface IUICopyCountDown extends IUIBase
	{
		function processCountDownUserCmd(msg:ByteArray):void;
	}
}