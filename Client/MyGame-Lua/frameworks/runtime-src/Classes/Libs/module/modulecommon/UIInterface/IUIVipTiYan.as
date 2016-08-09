package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	/**
	 * @author ...
	 */
	public interface IUIVipTiYan extends IUIBase
	{
		function update(param:Object = null):void;
		function updateBtnEnbale(benable:Boolean):void;
		function psgetVip3PracticeRewardCmd(msg:ByteArray):void;
	}
}