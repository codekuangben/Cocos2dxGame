package modulecommon.uiinterface 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUIRadar extends IUIBase
	{
		function updateMapName():void;
		function updateBtnRadar():void;	
		function getBtnPosInRadarByIdx(id:int):Point;
		function showEffectAni(btnid:int):void;
		function hideEffectAni(btnid:int):void;
		function addNewFeatureBtn(type:uint):void;
		function showNewHand():void;
	}	
}