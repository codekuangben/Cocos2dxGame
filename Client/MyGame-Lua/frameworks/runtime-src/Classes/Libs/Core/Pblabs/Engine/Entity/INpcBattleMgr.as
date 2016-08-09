package com.pblabs.engine.entity 
{
	import org.ffilmation.engine.elements.fEmptySprite;

	/**
	 * ...
	 * @author 
	 * @brief 战斗 npc 管理器   
	 */
	public interface INpcBattleMgr 
	{
		function getBeingByID(id:String):BeingEntity;
		function getEmptySpriteByID(id:String):fEmptySprite;
	}
}