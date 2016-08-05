package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public interface IUIGamble  extends IUIBase
	{
		function processMsg(msg:ByteArray, param:int):void
		function updateMoney(dic:Dictionary):void
		function updateXingYunBi():void
	}
	
}