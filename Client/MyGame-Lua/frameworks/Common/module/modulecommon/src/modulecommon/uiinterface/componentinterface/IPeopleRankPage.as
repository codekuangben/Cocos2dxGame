package modulecommon.uiinterface.componentinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	
	public interface IPeopleRankPage 
	{
		function process_stRetRankRewardRankInfoCmd(msg:ByteArray):void
		function onNextDay():void
		function onLingqu(day:int):void
	}
	
}