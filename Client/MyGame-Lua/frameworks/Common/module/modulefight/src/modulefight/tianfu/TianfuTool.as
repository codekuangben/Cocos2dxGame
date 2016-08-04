package modulefight.tianfu 
{
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...
	 */
	public class TianfuTool 
	{
		
		public static function computeNumOfTianfu_Shenyi(fightDB:FightDB, team:int):int
		{
			var grids:Vector.<FightGrid> = fightDB.m_fightGridsWithBudui[team];
			var grid:FightGrid;
			var tianfu:TianfuBase;
			var ret:int=0;
			for each(grid in grids)
			{
				tianfu = grid.tianfu;
				if (tianfu && tianfu is Tianfu_Shenyi)
				{
					ret++;
				}
			}
			return ret;
		}
		
		public static function computeAddHP_Shenyi(addHP:Number, numSelfShenyi:int, numEnemyShenyi:int):int
		{
			var ret:Number = addHP;
			if (numSelfShenyi)
			{
				ret *= (1 + 0.3);				
			}
			if (numEnemyShenyi)
			{
				ret *= 0.5;
			}
			return ret;
		}
		
	}

}