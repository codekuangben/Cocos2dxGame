package modulefight.tianfu 
{
	/**
	 * ...
	 * @author 
	 * 李儒	攻击敌中军全体造成65%伤害	克敌:场上每有一名中军对敌伤害增加(4%/6%/8%/10%)

	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_Kedi extends TianfuBase 
	{
		
		public function Tianfu_Kedi() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[m_fightGrid.side];
			var i:int;
			var grid:FightGrid;
			for (i = 3; i < 6; i++)
			{
				grid = grids[i];
				if (grid.hasBuDui && !grid.isDie)
				{
					return true;
				}
			}
			
			grids = m_fightDB.m_fightGrids[1 - m_fightGrid.side];
			for (i = 3; i < 6; i++)
			{
				grid = grids[i];
				if (grid.hasBuDui && !grid.isDie)
				{
					return true;
				}
			}
			return false;
		}
	}

}