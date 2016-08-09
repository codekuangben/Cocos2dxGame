package modulecommon.uiinterface 
{
	import modulecommon.scene.wu.WuHeroProperty;
	/**
	 * ...
	 * @author ...
	 */
	public interface IUIWuXiaye extends IUIBase
	{
		function toNotXiaye(heroid:uint):void;
		function toXiaye(heroid:uint):void;
		function updateNotXiayeList():void;
		function removeWu(wu:WuHeroProperty):void;
		function updateWuNum(wu:WuHeroProperty):void
	}
}