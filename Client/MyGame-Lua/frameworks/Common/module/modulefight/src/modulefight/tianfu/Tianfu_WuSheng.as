package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 武圣:场上每死亡一人,对敌伤害提升5%	当场上已有部队死亡时,每次攻击时在部队上出现(无论普通攻击与技能攻击)
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_WuSheng extends TianfuBase 
	{
		
		public function Tianfu_WuSheng() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[0];
			var grid:FightGrid;
			for each(grid in grids)
			{
				if (grid.isDie)
				{
					return true;
				}
			}	
			
			grids = m_fightDB.m_fightGridsWithBudui[1-m_fightGrid.side];		
			for each(grid in grids)
			{
				if (grid.isDie)
				{
					return true;
				}
			}	
			return false;
		}
	}

}