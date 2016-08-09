package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUITongQueTai extends IUIBase
	{
		function updateHaogan():void	
		function addNormalDancer(id:int):void
		function addSpecialDancer(id:uint):void	
		function deleteSpecialDancer(id:uint):void
		function updateNumOfSpecialDancer(id:uint):void
		function updataIconName():void
	}
	
}