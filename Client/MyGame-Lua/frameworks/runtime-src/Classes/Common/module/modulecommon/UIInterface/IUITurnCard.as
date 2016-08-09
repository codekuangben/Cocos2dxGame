package modulecommon.uiinterface 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public interface IUITurnCard extends IUIBase
	{
		function parseCopyReward(byte:ByteArray):void;
		function set binFight(value:Boolean):void;
	}
}