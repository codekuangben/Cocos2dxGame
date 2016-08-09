package game.process 
{
	/**
	 * ...
	 * @author ...
	 */
	import game.ui.uibenefithall.msg.updateRewardBackCmd;
	import modulecommon.GkContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.activityCmd.stActivityCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIBenefitHall;
	import modulecommon.uiinterface.IUIGamble;
	import modulecommon.uiinterface.IUIVipTiYan;
	public class ActivityProcess 
	{
		private var m_gkcontext:GkContext;		
		private var dicFun:Dictionary;
		public function ActivityProcess(gk:GkContext) 
		{
			m_gkcontext = gk;
			dicFun = new Dictionary();
			dicFun[stActivityCmd.RET_DUGUAN_DATA_USERCMD] = processGamble;
			dicFun[stActivityCmd.RET_XIAZHU_USERCMD] = processGamble;
			dicFun[stActivityCmd.PARA_KAIJIANG_USERCMD] = processGamble;
			dicFun[stActivityCmd.FREE_XIAZHU_USERCMD] = m_gkcontext.m_gambleMgr.processFreeXiazhuUserCmd;
			dicFun[stActivityCmd.PARA_LIMIT_BIG_SEND_ACTINFO_CMD] = m_gkcontext.m_LimitBagSendMgr.process_stLimitBigSendActInfoCmd;
			dicFun[stActivityCmd.PARA_REFRESH_LBSA_PROGRESS_CMD] = m_gkcontext.m_LimitBagSendMgr.process_stRefreshLBSAProgressCmd;
			dicFun[stActivityCmd.PARA_REFRESH_LBSA_ITEM_INFO_CMD] = m_gkcontext.m_LimitBagSendMgr.process_stRefreshLBSAItemInfoCmd;
			dicFun[stActivityCmd.PARA_NOTIFY_LIMIT_BIG_SEND_ACT_STATE_CMD] = m_gkcontext.m_LimitBagSendMgr.process_stNotifyLimitBigSendActStateCmd;
			dicFun[stActivityCmd.NOTIFY_WELFARE_DATA_CMD] = m_gkcontext.m_welfarePackageMgr.process_notifyWelfareDataCmd;
			dicFun[stActivityCmd.BUY_WELFARE_DATA_CMD] = m_gkcontext.m_welfarePackageMgr.process_buyWelfareDataCmd;
			dicFun[stActivityCmd.GET_BACK_WELFARE_DATA_CMD] = m_gkcontext.m_welfarePackageMgr.process_getBackWelfareDataCmd;
			
			dicFun[stActivityCmd.PARA_SEVEN_LOGIN_AWARD_INFO_CMD] = m_gkcontext.m_qiridengluMgr.process_stSevenLoginAwardInfoCmd;
			dicFun[stActivityCmd.PARA_GET_SEVEN_LOGIN_REWARD_CMD] = m_gkcontext.m_qiridengluMgr.process_stGetSevenLoginRewardCmd;
			
			dicFun[stActivityCmd.PARA_UPDATE_FIX_LEVEL_REWARD_FLAG_CMD] = m_gkcontext.m_peopleRankMgr.process_stUpdateFixLevelRewardFlagCmd;
			dicFun[stActivityCmd.PARA_FIX_LEVEL_REWARD_INFO_CMD] = m_gkcontext.m_peopleRankMgr.process_stFixLevelRewardInfoCmd;
			dicFun[stActivityCmd.PARA_RET_RANK_REWARD_RANK_INFO_CMD] = process_stRetRankRewardRankInfoCmd;
			dicFun[stActivityCmd.NOTIFY_RECHARGE_BACK_DATA_CMD] = m_gkcontext.m_rechargeRebateMgr.process_notifyRechargeBackDataCmd;
			dicFun[stActivityCmd.UPDATE_RECHARGE_YUANBAO_CMD] = m_gkcontext.m_rechargeRebateMgr.process_updateRechargeYuanbaoCmd;
			dicFun[stActivityCmd.GET_RECHARGE_BACK_REWARD_CMD] = m_gkcontext.m_rechargeRebateMgr.process_getRechargeBackRewardCmd;
			dicFun[stActivityCmd.UPDATE_REWARD_BACK_CMD] = psupdateRewardBackCmd;
			dicFun[stActivityCmd.DT_NOTIFY_RECHARGE_BACK_DATA_CMD] = m_gkcontext.m_dtRechargeRebateMgr.process_dtNotifyRechargeBackDataCmd;
			dicFun[stActivityCmd.DT_UPDATE_RECHARGE_YUANBAO_CMD] = m_gkcontext.m_dtRechargeRebateMgr.process_dtUpdateRechargeYuanbaoCmd;
			dicFun[stActivityCmd.DT_GET_RECHARGE_BACK_REWARD_CMD] = m_gkcontext.m_dtRechargeRebateMgr.process_dtGetRechargeBackRewardCmd;
			
			dicFun[stActivityCmd.GET_VIP3_PRACTICE_REWARD_CMD] = psgetVip3PracticeRewardCmd;
		}
		public function process(msg:ByteArray, param:uint):void
		{
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg, param);
			}
		}
		
		//处理赌博消息
		public function processGamble(msg:ByteArray, param:uint):void
		{
			var ui:IUIGamble = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGamble) as IUIGamble;
			if (ui != null)
			{
				ui.processMsg(msg, param);
			}
		}		
		
		public function process_stRetRankRewardRankInfoCmd(msg:ByteArray, param:uint):void
		{
			if (m_gkcontext.m_peopleRankMgr.m_page)
			{
				m_gkcontext.m_peopleRankMgr.m_page.process_stRetRankRewardRankInfoCmd(msg);
			}
		}
		
		public function psupdateRewardBackCmd(msg:ByteArray, param:uint):void
		{
			m_gkcontext.m_jlZhaoHuiMgr.bnewMsg = true;
			m_gkcontext.m_contentBuffer.addContent("updateRewardBackCmd", msg);
			
			var cmd:updateRewardBackCmd = new updateRewardBackCmd();
			cmd.deserialize(msg);
			msg.position = 0;
			if (cmd.data.length == 0)
			{
				m_gkcontext.m_contentBuffer.addContent("JLZHListTabPage", false);
				m_gkcontext.m_benefitHallMgr.onNotify_noReward(BenefitHallMgr.BUTTON_JLZhaoHui);
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("JLZHListTabPage", true);
				m_gkcontext.m_benefitHallMgr.onNotify_hasReward(BenefitHallMgr.BUTTON_JLZhaoHui);
			}
			var form:IUIBenefitHall = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBenefitHall) as IUIBenefitHall;
			if (form)
			{
				if (cmd.data.length == 0)
				{
					form.removePage(BenefitHallMgr.BUTTON_JLZhaoHui);
					form.openPage(BenefitHallMgr.BUTTON_HuoyueFuli);
				}
				else
				{
					form.addPage(BenefitHallMgr.BUTTON_JLZhaoHui);
					form.psupdateRewardBackCmd(msg);
				}
			}
		}
		
		public function psgetVip3PracticeRewardCmd(msg:ByteArray, param:uint):void
		{
			var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
			if (vipty)
			{
				vipty.psgetVip3PracticeRewardCmd(msg);
			}
		}
	}
}