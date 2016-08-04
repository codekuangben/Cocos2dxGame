package game.ui.uipaoshangsys.mark
{
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import modulecommon.uiObject.UIMBeing;
	
	/**
	 * @brief
	 */
	public interface IMarkData
	{
		function dispose():void;
		function clearHero(stateinfo:BusinessUser):void;
		function createHero(stateinfo:BusinessUser):void;
		function getIDByBeing(being:UIMBeing):uint;
		function isSelf(being:UIMBeing):Boolean;
	}
}