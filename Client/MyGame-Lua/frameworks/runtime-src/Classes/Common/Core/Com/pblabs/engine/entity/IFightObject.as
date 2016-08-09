package com.pblabs.engine.entity
{
	import common.scene.fight.AttackItem;
	import common.scene.fight.HurtItem;
	/**
	 * ...
	 * @author 
	 * @brief 战斗接口   
	 */
	public interface IFightObject 
	{
		function playAttack(item:AttackItem):void;
		function playHurt(item:HurtItem):void
	}
}