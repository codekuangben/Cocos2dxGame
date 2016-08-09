package modulecommon.uiinterface 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUITreasureHunt extends IUIBase
	{
		function updataLeftPart(strlist:Array,strlistv:Array):void
		function updataRightPart(strlist:Array):void
		function processMsg_stHuntingResultCmd(msg:ByteArray):void
		function refrashScore():void
	}
	
}