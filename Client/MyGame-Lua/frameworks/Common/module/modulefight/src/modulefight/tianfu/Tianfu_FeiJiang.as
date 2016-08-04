package modulefight.tianfu
{
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.netmsg.stmsg.stStrikeBack;
	import modulefight.scene.fight.FightGrid;
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author ...
	 * 场上每有一个己军时,出现暴击几率提升5%
	 *
	 * 130-吕布
	 */
	public class Tianfu_FeiJiang extends TianfuBase
	{
		
		public function Tianfu_FeiJiang()
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		
		override public function isTriger(param:Object = null):Boolean
		{
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[m_fightGrid.side];
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