package modulecommon.uiinterface
{
	
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.scene.prop.object.ZObject
	import modulecommon.scene.wu.WuProperty;
	public interface IUIBackPack extends IUIBase
	{
		function addObject(obj:ZObject):void;
		function removeObject(obj:ZObject):void;
		function updateObject(obj:ZObject):void;
		function updateHero(id:uint):void;
		function updateWu():void;		
		function addWu(heroID:uint):void;
		function generateBtnList():void;
		function onWuNumChange(heroid:int):void;
		function removeWu(heroID:uint):void;
		function switchToHero(heroID:uint):void;
		function updateAllObjects():void;		
		function updateFastZhuanshengForm():void
		function updateHeroTrain(id:uint = 0):void
		function updateZhanshu():void;
		function updateLocState(oldOpenedSize:int, nowOpenedSize:int):void
		function updateNextOpenedGrid():void
		function reloadCommonObjects():void
		function reloadBaowuPackage():void
		function addXiayeWu(wu:WuProperty):void;
		function removeXiayeWu(wu:WuProperty):void;
		function onShowRelationWuPanel():void;
		function onShowPackage():void;
		function hideNextRelationWuListByHeroID(heroid:uint):void;
		function actSuccessUAR(groupid:uint):void;
	}
}