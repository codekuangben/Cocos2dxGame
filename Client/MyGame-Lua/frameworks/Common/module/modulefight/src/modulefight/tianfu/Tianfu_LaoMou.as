package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 老谋:场上每有一个中军,则增加5%对敌伤害
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_LaoMou  extends TianfuBase 
	{
		
		public function Tianfu_LaoMou() 
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