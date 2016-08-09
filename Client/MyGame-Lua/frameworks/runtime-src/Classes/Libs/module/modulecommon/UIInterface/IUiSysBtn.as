package modulecommon.uiinterface 
{
	import com.bit101.components.ButtonAni;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUiSysBtn 
	{
		function getWuJiangPosInScreen():Point;
		function addNewFeature(type:uint, btn:ButtonAni = null):void;
		function getButtonPosInScreen(type:uint):Point;
		function vacateRoomForButton(type:uint):void;
		function updateExpCount():void;
		function getButton(type:uint):ButtonAni;
		function getBtnPosInScreenByIdx(idx:uint):Point;
		function addNewOneSysBtn(type:uint):void;
		function getCurExpPos():Point;
		function showEffectAni(btnid:int):void
		function hideEffectAni(btnid:int):void
		
		function moveToLayer(layerID:uint):void;
		function moveBackFirstLayer():void;
	}
	
}