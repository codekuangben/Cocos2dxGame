package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 遗志:场上每有一个敌人，运气提升10%	每回合初自身上出现
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_YiZhi extends TianfuBase 
	{
		
		public function Tianfu_YiZhi() 
		{
			super();
			m_type = TYPE_RoundBegin;
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