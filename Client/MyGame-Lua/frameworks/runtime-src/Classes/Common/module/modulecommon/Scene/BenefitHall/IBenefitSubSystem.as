package modulecommon.scene.benefithall 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IBenefitSubSystem 
	{
		/*计算当前是否奖励可领取
		 * id: BenefitHallMgr.BUTTON_HuoyueFuli等定义
		 */
		function hasReward(id:int):Boolean;
		
		/*计算当前是否奖励可领取
		 * 通知BenefitHallMgr对象，id所对应系统的奖励可以领取了
		 */
		function notify_hasReward(id:int):void;
		/*计算当前是否奖励可领取
		 * 通知BenefitHallMgr对象，id所对应系统的没有奖励可以领取了
		 */
		function notify_noReward(id:int):void;
	}
	
}