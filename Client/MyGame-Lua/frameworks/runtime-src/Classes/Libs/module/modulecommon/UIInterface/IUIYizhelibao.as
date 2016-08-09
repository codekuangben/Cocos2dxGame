package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIYizhelibao  extends IUIBase
	{
		function updateYuanbao():void
		function onBuyCommodity(level:int, commodityID:int):void
		function showForLevelup():void
	}
	
}