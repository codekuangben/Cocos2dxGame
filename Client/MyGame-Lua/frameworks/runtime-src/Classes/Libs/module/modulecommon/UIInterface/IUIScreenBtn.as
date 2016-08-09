package modulecommon.uiinterface 
{
	import com.bit101.components.ButtonAni;
	import flash.geom.Point;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIScreenBtn  extends IUIBase
	{
		function toggleBtnVisible(btnid:uint, bvis:Boolean):void;
		function addNewFeature(type:uint, btn:ButtonAni = null):void;
		function getButtonPosInScreen(id:int):Point;
		function vacateRoomForButton(type:uint):void;
		function getButton(id:int):ButtonAni;
		function updateSaoDangTime(time:uint):void;
		function saoDangBtnState():uint;
		function setNewButtonPos(id:int):void;
		function getButtonPosInScreenEx(id:int):Point;
		function updateGiftTime(time:uint):void;
		function addBtnByID(btnid:uint):void;
		function isVisibleBtn(btnid:uint):Boolean;
		function updateBtnEffectAni(btnid:int, bool:Boolean = false,path:String=null):Boolean;
		function updateLblCnt(cnt:uint, btnid:uint, type:int = ScreenBtnMgr.LBLCNTBGTYPE_Red):void;
		function removeBtn(id:int):void;
		function getBtnPosInScreen(id:int):Point;
		function changeBtnIcon(btnid:uint, iconname:String):Boolean;
		function updateVipTY(time:uint):void;
		function firstRechargeVisible(bvis:Boolean):void;
		function updateBtnOfCorpsTreasure():void;
	}
}