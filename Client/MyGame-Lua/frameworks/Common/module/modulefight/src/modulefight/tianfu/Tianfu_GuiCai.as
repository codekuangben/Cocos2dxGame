package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 鬼才:场上每有一个后军,则增加5%对敌伤害	当场上还有存活的后军时,每次攻击时在部队上出现(无论普通攻击与技能攻击)
	 */
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_GuiCai extends TianfuBase 
	{
		
		public function Tianfu_GuiCai() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[0];
			var grid:FightGrid;	
			var i:int;
			for (i = 6; i < 9; i++)
			{
				grid = grids[i];
				if (grid.hasBuDui && !grid.isDie)
				{
					return true;
				}
			}
			grids = m_fightDB.m_fightGrids[0];
			for (i = 6; i < 9; i++)
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