package modulefight.ui.hpstrip
{
	import com.bit101.components.progressBar.ProgressBar;
	import modulecommon.GkContext;
	import modulefight.scene.fight.FightGrid;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.ui.battlehead.BattleHPBarInProgressLeftMul;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author
	 */
	public class HPStripLeft extends HPStripBase
	{
		
		public function HPStripLeft(grid:FightGrid, gk:GkContext)
		{
			super(grid, gk);
			m_bufferInterval = 30;
			m_barClass = BattleHPBarInProgressLeftMul;
		}
		
		
	
	}

}