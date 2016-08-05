package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public interface IUIMail extends IUIBase 
	{
		function processMsg(msg:ByteArray, param:uint):void
		function processMailListCmd():void
	}
	
}