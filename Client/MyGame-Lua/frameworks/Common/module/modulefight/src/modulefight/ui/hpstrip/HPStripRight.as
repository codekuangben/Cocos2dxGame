package modulefight.ui.hpstrip 
{
	import modulecommon.GkContext;
	import modulefight.scene.fight.FightGrid;
	import modulefight.ui.battlehead.BattleHPBarInProgressRightMul;
	
	/**
	 * ...
	 * @author 
	 */
	public class HPStripRight extends HPStripBase 
	{
		
		public function HPStripRight(grid:FightGrid, gk:GkContext) 
		{
			super(grid, gk);
			m_barClass = BattleHPBarInProgressRightMul;
			m_bufferInterval = -30;
		}
		
	}

}