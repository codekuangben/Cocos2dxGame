package modulecommon.uiinterface 
{
	import modulecommon.scene.beings.MountsSkillTipData;
	import modulecommon.scene.prop.object.ZObject;
	import flash.geom.Point;
	import com.bit101.components.Component;
	import modulecommon.scene.beings.MountsTipData;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public interface IUITip
	{
		function hintObjectInfo(pt:Point, obj:ZObject, contrastHeroID:uint=0):void
		function hintEquipObjForHecheng(pt:Point, obj:ZObject):void
		function hintEquipObjForColorAdvance(pt:Point, obj:ZObject):void
		function hintEquipObjForLevelAdvance(pt:Point, obj:ZObject):void
		function hintEquipObjForFirstRecharge(pt:Point, obj:ZObject):void
		function hideTip():void
		function hintHtiml(xPos:int, yPos:int, html:String, width:int = 266, onTop:Boolean=false, leading:int=-1):void
		function hintSkillInfo(pos:Point, skillID:uint, offsetX:int = 0):void
		function hintSkillInfoForTianfu(pos:Point, skillID:uint, offsetX:int = 0, lastText:String = null):void;
		function hintWu(pos:Point, heroID:uint, offsetX:int=0):void
		function hintCondense(pos:Point, str:String):void
		function hintActiveWu(pos:Point, wuID:uint, activeWuID:uint, offsetX:int = 0):void;
		function hintActiveWu_watch(pos:Point, wuID:uint, activeWuID:uint, bOwned:Boolean):void
		function hintActiveWuRelation(pos:Point, wuID:uint):void;
		function hintComponent(pos:Point, com:Component, offsetX:int = 0):void
		function hintWuBaseInfo(pos:Point, wuID:uint, offsetX:int = 0):void
		function hintWuBaseInfo2(pos:Point, heroID:uint, offsetX:int = 0):void
		function hintRecruitWu(pos:Point, wuID:uint, offsetx:int = 0):void;
		function hintMountsInfo(pos:Point, mountsdata:MountsTipData, position:int = 0, bSelf:Boolean = false):void;
		function hintMountsSkillInfo(pos:Point, tipsData:MountsSkillTipData):void;
	}
}