package game.process 
{
	/**
	 * ...
	 * @author 
	 * 竞技场
	 */
	
	import flash.utils.ByteArray;
	import modulecommon.GkContext;	
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiPkCountUserCmd;
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiPkDaoJiShiUserCmd;
	//import modulecommon.scene.prop.BeingProp;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	
	public class ArenaProcess extends ProcessBase 
	{		
		public function ArenaProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stGuanZhiJingJiCmd.RET_GUAN_ZHI_JING_JI_REVIEW_LIST] = processGuanZhiJingJIReviewList;
			dicFun[stGuanZhiJingJiCmd.UPDATE_ONE_GUAN_ZHI_JING_JI_REVIEW] = processGuanZhiJingJIReviewList;
			dicFun[stGuanZhiJingJiCmd.RET_RANK_LIST_USERCMD] = processRankListCmd;
			dicFun[stGuanZhiJingJiCmd.GUAN_ZHI_JING_JI_PK_COUNT_USERCMD] = processPkCountCmd;
			dicFun[stGuanZhiJingJiCmd.GUAN_ZHI_JING_JI_PK_DAO_JI_SHI_USERCMD] = processDaoJiShiCmd;
			dicFun[stGuanZhiJingJiCmd.RET_30_RANK_LIST_USERCMD] = process30RankListCmd;
			dicFun[stGuanZhiJingJiCmd.NOTIFY_THREE_FIXED_CHARID_USERCMD] = m_gkContext.m_arenaMgr.parseNotifyThreeFixedCharID;	// 
			dicFun[stGuanZhiJingJiCmd.NOTIFY_GUANZHI_NAME_USERCMD] = m_gkContext.m_arenaMgr.processNotifyGuanzhiNameUserCmd;
			dicFun[stGuanZhiJingJiCmd.NOTIFY_CLEAR_GUANZHI_NAME_USERCMD] = m_gkContext.m_arenaMgr.processNotifyClearGuanzhiNameUserCmd;
			dicFun[stGuanZhiJingJiCmd.NOTIFY_NINE_GUANZHI_NAME_USERCMD] = m_gkContext.m_arenaMgr.processNotifyNineGuanzhiNameUserCmd;
		}
		
		private function processGuanZhiJingJIReviewList(msg:ByteArray, param:uint):void
		{			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaInfomation) as IForm;
			if (form)
			{
				var uiParam:Object = new Object();
				uiParam["msg"] = msg;
				uiParam["param"] = param;
				form.updateData(uiParam);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("uiArenaInfomation_list", msg);
			}
		}
		
		private function processRankListCmd(msg:ByteArray, param:uint):void
		{
			m_gkContext.m_contentBuffer.addContent("uiArenaLadder_list", msg);
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaLadder) as IForm;
			if (form)
			{
				form.updateData();
			}
		}
		
		private function processPkCountCmd(msg:ByteArray, param:uint):void
		{
			var rev:stGuanZhiJingJiPkCountUserCmd = new stGuanZhiJingJiPkCountUserCmd();
			rev.deserialize(msg);
						
			m_gkContext.m_arenaMgr.setPKCount(rev.count);
		}
		
		private function processDaoJiShiCmd(msg:ByteArray, param:uint):void
		{
			var rev:stGuanZhiJingJiPkDaoJiShiUserCmd = new stGuanZhiJingJiPkDaoJiShiUserCmd();
			rev.deserialize(msg);
			
			m_gkContext.m_arenaMgr.updateColdTimeDaojishi(rev.time);
		}
		
		private function process30RankListCmd(msg:ByteArray, param:uint):void
		{
			m_gkContext.m_contentBuffer.addContent("uiArenaBetialRank_list", msg);
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIArenaBetialRank) as IForm;
			if (form)
			{
				form.updateData();
			}
		}	
	}
}