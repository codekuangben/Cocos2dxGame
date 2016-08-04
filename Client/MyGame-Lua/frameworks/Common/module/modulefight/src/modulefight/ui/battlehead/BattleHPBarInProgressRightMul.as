package modulefight.ui.battlehead 
{
	
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import modulecommon.GkContext;
	import modulefight.ui.progressbar.HLayerBase;
	import modulefight.ui.progressbar.HLayerRight;
	public class BattleHPBarInProgressRightMul extends BattleHPBarInProgressMulBase
	{				
		public function BattleHPBarInProgressRightMul(gk:GkContext) 
		{
			super(gk);		
		}
		
		override protected function createLayer():HLayerBase
		{
			return new HLayerRight(this);
		}
	}

}