package modulecommon.uiinterface
{	
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public interface IUIGiftPack extends IUIBase
	{
		function newForm(id:uint):void;
		function delForm(id:uint):void;
		function processOnlineGiftContent(msg:ByteArray):void;
		function updateTimeLabel(id:uint, time:uint):void;
		function processLevelGiftContent(msg:ByteArray):void;
		function processRetRandomGiftContent(msg:ByteArray):void;
		function processRetActLibaoContentCmd(msg:ByteArray):void;
		function hideObjPnl(id:uint):void;
		function reqOnlineGiftContent():void;
	}
}