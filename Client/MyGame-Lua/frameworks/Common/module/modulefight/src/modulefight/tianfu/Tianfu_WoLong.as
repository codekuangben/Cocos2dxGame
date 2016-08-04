package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 卧龙:场上每有一个敌军时,出现暴击几率提升10%
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_WoLong extends TianfuBase 
	{
		
		public function Tianfu_WoLong() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[1-m_fightGrid.side];		
			var grid:FightGrid;	
			for each(grid in grids)
			{
				if (!grid.isDie)
				{
					return true;
				}
			}			
			return false;
		}
	}

}