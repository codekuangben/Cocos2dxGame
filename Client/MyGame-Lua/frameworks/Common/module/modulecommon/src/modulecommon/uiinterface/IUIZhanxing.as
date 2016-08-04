package modulecommon.uiinterface 
{
	import modulecommon.scene.zhanxing.ZStar;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIZhanxing extends IUIBase 
	{
		function updateLightWuhu():void
		function addStarFromTanfang(star:ZStar, heronum:int):void
		function addStar(star:ZStar):void
		function removeStar(obj:ZStar):void
		function updateStar(obj:ZStar):void
		//function updateYinbi():void
		function updateLocState(location:int, oldOpenedSize:int, nowOpenedSize:int):void
		function updateEquipLocState():void
		function updateWuxue(type:int):void
		function updataLbsysText():void
		function autoTangfang():void
		function autoHeCheng():void
		function get checkState():Boolean
		function hechengBtnEnable(enable:Boolean):void
		function refreshScore():void
		function refreshSilverTimes():void
	}
	
}