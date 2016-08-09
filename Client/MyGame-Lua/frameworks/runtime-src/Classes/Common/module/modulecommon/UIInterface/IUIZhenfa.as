package modulecommon.uiinterface 
{
	import modulecommon.scene.wu.WuProperty;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUIZhenfa  extends IUIBase
	{		
		function setWuPos(heroID:uint, gridNO:int):void;
		function clearWuByPos(gridNO:int):void;	
		function buildList():void;
		function clearJinnang(pos:int):void
		function setJinnang(idInit:uint, pos:int):void
		function onLevelup():void
		function addWu(heroID:uint):void;
		function openGrid(gridNo:int):void;
		function updateAllWuZhanli():void;
		function updateZhenfaHerosUp():void;
		function updateJinnangGrid():void;
		function addXiayeWu(wu:WuProperty):void;
		function removeXiayeWu(wu:WuProperty):void;
		function updateXiayeWuNum(wu:WuProperty):void;
	}
	
}