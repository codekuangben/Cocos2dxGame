package modulefight.tianfu 
{
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...
	 * 神勇:本军前军无人生存时,对敌伤害提升50%
	 */
	public class Tianfu_ShenYong extends TianfuBase 
	{
		
		public function Tianfu_ShenYong() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[m_fightGrid.side];
			var i:int;
			var grid:FightGrid;
			for (i = 0; i < 3; i++)
			{
				grid = grids[i];
				if (grid.hasBuDui && !grid.isDie)
				{
					return false;
				}
			}
			return true;
		}
	}

}