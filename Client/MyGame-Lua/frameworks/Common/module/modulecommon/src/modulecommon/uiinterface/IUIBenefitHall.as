package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	
	/**
	 * @brief 大厅
	 */
	public interface IUIBenefitHall extends IUIBase
	{
		function addPage(id:int):void;
		function removePage(id:int):void;
		function openPage(id:int = BenefitHallMgr.BUTTON_Num):void;
		function updateDataOnePage(id:int = BenefitHallMgr.BUTTON_Num, param:Object = null):void;
		function showRewardFlag(id:int, bShow:Boolean):void;
		function psupdateRewardBackCmd(msg:ByteArray):void;
	}
}