package modulefight.ui.battlehead 
{
	
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.GkContext;
	import modulefight.ui.progressbar.HLayerBase;
	import modulefight.ui.progressbar.HLayerLeft;
	public class BattleHPBarInProgressLeftMul extends BattleHPBarInProgressMulBase 
	{
		
		public function BattleHPBarInProgressLeftMul(gk:GkContext) 
		{
			super(gk);			
		}
		
		override protected function createLayer():HLayerBase
		{
			return new HLayerLeft(this);
		}
	}

}