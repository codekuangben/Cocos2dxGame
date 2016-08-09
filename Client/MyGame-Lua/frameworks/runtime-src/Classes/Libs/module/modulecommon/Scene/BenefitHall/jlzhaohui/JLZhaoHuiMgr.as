package modulecommon.scene.benefithall.jlzhaohui
{
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	/**
	 * @brief 奖励找回
	 */
	public class JLZhaoHuiMgr implements IBenefitSubSystem
	{
		private var m_gkContext:GkContext;
		private var m_bnewMsg:Boolean;			// 如果是新的消息就需要更新
		
		public function JLZhaoHuiMgr(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		public function hasReward(id:int):Boolean
		{
			return false;
		}
		
		public function notify_hasReward(id:int):void
		{
			
		}

		public function notify_noReward(id:int):void
		{
			
		}
		
		public function get bnewMsg():Boolean
		{
			return m_bnewMsg;
		}
		
		public function set bnewMsg(value:Boolean):void
		{
			m_bnewMsg = value;
		}
	}
}