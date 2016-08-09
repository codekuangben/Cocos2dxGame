package modulecommon.uiinterface 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	public interface IUIFuben extends IUIBase
	{		
		function processMsg(msg:ByteArray, param:uint):void;		
	}

}