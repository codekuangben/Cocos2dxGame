package game.ui.recharge 
{
	import flash.events.MouseEvent;
	import modulecommon.net.msg.activityCmd.dtGetRechargeBackRewardCmd;
	/**
	 * 定时充值返利界面项目
	 * @author 
	 */
	public class DTRechargeRebateItem extends RechargeRebateItem 
	{
		
		public function DTRechargeRebateItem(param:Object=null) 
		{
			super(param);
		}
		/**
		 * 更新按钮
		 */
		override protected function updateBtn():void 
		{
			if (m_gkcontext.m_dtRechargeRebateMgr.isReceived(m_id))//已经领取过
			{
				updateBtnToReceive();
			}
			else 
			{
				updateNoReceiveBtn();
			}
		}
		override public function updateNoReceiveBtn():void 
		{
			if (m_gkcontext.m_dtRechargeRebateMgr.cumulativeYB >= m_data.m_numYB)
			{
				m_btnReceive.setSkinButton1Image("module/benefithall/xianshifangsong/btnable.png");
				m_btnReceive.enabled = true;
			}
			else
			{
				m_btnReceive.setSkinButton1Image("module/benefithall/rebate/btnnotcatch.png");
				m_btnReceive.enabled = false;
			}
		}
		override protected function receiveClick(e:MouseEvent):void 
		{
			var send:dtGetRechargeBackRewardCmd = new dtGetRechargeBackRewardCmd();
			send.m_index = m_id;
			m_gkcontext.sendMsg(send);
		}
		
	}

}