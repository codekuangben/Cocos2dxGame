package modulecommon.uiinterface 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IUIXingMai  extends IUIBase
	{
		function updateXingLi(xingli:uint):void;
		function updateJiangHun():void;
		function updateAttrLevel(id:uint):void;
		function updateUsingSkill():void;
		function openOneNewXMSkill():void;
		function reSetDefaultUsingSkill():void;
		function updateActWuState(heroid:uint):void;
		function successSkillLevelUp(skillid:uint):void;
		function hideNextRelationWuListByHeroID(heroid:uint):void;	
	}
	
}