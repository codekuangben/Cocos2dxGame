package modulecommon.uiinterface
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.wu.WuProperty;
	/**
	 * ...
	 * @author 
	 */
	public interface IUIEquipSys extends IUIBase
	{
		function parseServerMsg(msg:ByteArray, param:uint):void;		
		function updateGemInPackage():void;
		function freshObject(obj:ZObject):void;
		function updateOnObjectNumChange(obj:ZObject):void;
		function updateEquipEnchanceCold():void;
		function showPromptEquipEnchanceCold():void;
		function openPage(pageID:int):void
		function addEquip(obj:ZObject):void
		function addWu(wu:WuProperty):void
		function removeWu(wu:WuProperty):void
		function sortList():void
	}
}