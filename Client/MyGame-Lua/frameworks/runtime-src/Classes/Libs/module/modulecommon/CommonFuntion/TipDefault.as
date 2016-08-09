package modulecommon.commonfuntion 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.Component;
	import modulecommon.scene.beings.MountsSkillTipData;
	
	import flash.geom.Point;
	
	import modulecommon.scene.beings.MountsTipData;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.uiinterface.IUITip;

	public class TipDefault implements IUITip 
	{		 
		public function TipDefault(){}
		public function hintObjectInfo(pt:Point, obj:ZObject, contrastHeroID:uint=0):void { }
		public function hintEquipObjForHecheng(pt:Point, obj:ZObject):void { }
		public function hintEquipObjForColorAdvance(pt:Point, obj:ZObject):void { }
		public function hintEquipObjForLevelAdvance(pt:Point, obj:ZObject):void{}
		public function hintEquipObjForFirstRecharge(pt:Point, obj:ZObject):void { }
		public function hideTip():void{}
		public function hintHtiml(xPos:int, yPos:int, html:String, width:int = 266, onTop:Boolean=false, leading:int=-1):void{}
		public function hintSkillInfo(pos:Point, skillID:uint, offsetX:int = 0):void { }
		public function hintSkillInfoForTianfu(pos:Point, skillID:uint, offsetX:int = 0, lastText:String = null):void{}
		public function hintWu(pos:Point, heroID:uint, offsetX:int=0):void{}
		public function hintCondense(pos:Point, str:String):void{}
		public function hintActiveWu(pos:Point, wuID:uint, activeWuID:uint, offsetX:int = 0):void { }
		public function hintActiveWu_watch(pos:Point, wuID:uint, activeWuID:uint, bOwned:Boolean):void{}
		public function hintActiveWuRelation(pos:Point, wuID:uint):void{}
		public function hintComponent(pos:Point, com:Component, offsetX:int = 0):void{}
		public function hintWuBaseInfo(pos:Point, wuID:uint, offsetX:int = 0):void { }
		public function hintWuBaseInfo2(pos:Point, heroID:uint, offsetX:int = 0):void { }
		public function hintRecruitWu(pos:Point, wuID:uint, offsetx:int = 0):void { }
		public function hintMountsInfo(pos:Point, mountsdata:MountsTipData, position:int = 0, bSelf:Boolean = false):void { }
		public function hintMountsSkillInfo(pos:Point, tipsData:MountsSkillTipData):void{ }
	}

}