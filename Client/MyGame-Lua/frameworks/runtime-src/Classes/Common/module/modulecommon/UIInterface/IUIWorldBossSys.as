package modulecommon.uiinterface 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public interface IUIWorldBossSys extends IUIBase
	{
		function processWorldBossCmd(msg:ByteArray, param:int):void;
		function openUI(formid:uint):Boolean;
		function updateLeftTime(str:String):void;
		function updateBossHpInfoData():void;
	}

}