package modulecommon.uiinterface
{
	import flash.utils.ByteArray;

	public interface IUICorpsInfo extends IUIBase
	{		
		function openPage(pageID:int):void
		function processCmd(msg:ByteArray, param:uint):void
		function onWuziChange():void;
		function updateCorpsBoxNums():void
		function updateCoolDownForMain():void
		function updateCoolDownForKeji():void
		function updateDataByPage(pageID:int):void;
	}
}