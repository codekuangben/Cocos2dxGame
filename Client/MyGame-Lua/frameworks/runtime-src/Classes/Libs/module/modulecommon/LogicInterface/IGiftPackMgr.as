package modulecommon.logicinterface
{
	import flash.utils.ByteArray;
	//import flash.utils.Dictionary;
	import modulecommon.commonfuntion.GiftAniData;

	/**
	 * ...
	 * @author 
	 * @brief 礼包数据存放的地方
	 */
	public interface IGiftPackMgr 
	{
		function get uilist():Vector.<uint>;
		function showGiftPack(id:uint):void;
		function processNotifyOnlineGift(msg:ByteArray):void;
		function get lastTime():Number;
		function get id():uint;
		function set showBtn(value:Boolean):void;
		function get showBtn():Boolean;
		function set binit(value:Boolean):void;
		function get binit():Boolean;
		function get giftAniData():GiftAniData;
		function processFirstChargeGiftboxInfoCmd(msg:ByteArray):void;
		function processFirstChargeBoxStateCmd(msg:ByteArray):void;
		function processNotifyActLibaoStateCmd(msg:ByteArray):void;
		function get isFirstRecharge():Boolean;
		function get isGetFRGift():Boolean;
		function getFRGList():Array;
		function get hdlbState():uint;
		function set bHDLBClickBtn(bool:Boolean):void;
		function get bHDLBClickBtn():Boolean;
		
		function get lingquType():uint;
		function set lingquType(value:uint):void;
		
		function changeDJS(totaltime:uint):void;
		function get reqType():uint;
		function set reqType(value:uint):void;
		function reqLB():void;
		function showWuJiang():void;
		
		function get WJID():uint;
		function set WJID(value:uint):void;
		function getIcon(brecode:Boolean = true):String;
		function logInfo(wjid):void;
	}
}