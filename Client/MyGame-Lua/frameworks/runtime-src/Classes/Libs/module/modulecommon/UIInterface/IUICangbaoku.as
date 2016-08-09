package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	import modulecommon.ui.Form;

	public interface IUICangbaoku extends IUIBase
	{
		function updateUIList(type:uint = 0, idx:uint = 0):void;
		function updateUIAttr():void;
		function updateFaceLook():void;
		function processRetBoxTipContextUserCmd(msg:ByteArray, param:int):void;
		function updateColdTime():void;
		function openJiasuDialog():void;
		
		function openGiveUp():void;
		function openOpenBox():Form;
	}
}