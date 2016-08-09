package modulecommon.uiinterface 
{
	//import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUIHero extends IUIBase
	{
		function updateAlldata():void;
		function updateLevel():void;
		function updateGamemoney():void;
		function updateRMB():void;
		function updateLingpai():void;
		function upZongZhanli():void;
		function updateJianghun():void;
		function updateHeroName():void;
		function updateVipLevel():void;
		function getButtonPosInScreen(type:uint):Point;
		function showNewHand():void;
		function showTaskAni():void; 
		function toggleAutoWay(bshow:Boolean):void;
		function buyLingpai():void;
		function showRecharge():void;
		function showCorpsIcon():void;
		function addBufferIcon(type:int, bufferid:uint):void;
		function removeBufferIcon(bufferid:uint):void;
		function updateBufferIcon(type:int, bufferid:uint):void;
		function updateBufferEnabled(type:int, bEnabled:Boolean):void;
		function updateLeftTimes(bufferid:uint, value:uint):void;
		function showMountIcon():void;
		function hideMountIcon():void;
		function updateGodlyWeapon(id:uint, type:uint):void;
		function showGodlyWeapon():void;
		function updateGodlyIconFlashing(bflash:Boolean):void;
	}
}