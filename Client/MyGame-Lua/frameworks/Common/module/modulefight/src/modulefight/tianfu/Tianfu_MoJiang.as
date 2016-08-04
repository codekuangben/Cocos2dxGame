package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 魔将:场上每死亡一人,自身暴击出现几率提升20%
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_MoJiang extends TianfuBase 
	{
		
		public function Tianfu_MoJiang() 
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
			grids = m_fightDB.m_fightGridsWithBudui[1];
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