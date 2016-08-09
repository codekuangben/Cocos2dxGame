package modulecommon.uiinterface
{
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author 
	 */
	public interface IUIZhanYiResult extends IUIBase
	{
		function parseTiaoZhanResult(msg:ByteArray):void;
	}
}