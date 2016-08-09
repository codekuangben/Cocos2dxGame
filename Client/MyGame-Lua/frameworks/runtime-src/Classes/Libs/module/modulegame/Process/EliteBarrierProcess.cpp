package game.process 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.eliteBarrierCmd.stLeftTiaoZhanOnlineCmd;
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.net.msg.eliteBarrierCmd.stEliteBarrierCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stRetBarrierDataCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stRetCurBarrierCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stRetSlaveInfoToClietCmd;
	import modulecommon.scene.elitebarrier.EliteBarrierMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUIZhanYiResult;
	
	public class EliteBarrierProcess 
	{
		private var m_gkcontext:GkContext;
		private var m_eliteBarrierMgr:EliteBarrierMgr;
		private var dicFun:Dictionary;
		public function EliteBarrierProcess(gk:GkContext) 
		{
			m_gkcontext = gk;
			dicFun = new Dictionary();
			/*dicFun[stEliteBarrierCmd.PARA_RET_UIINFO_CMD] = processRetUIInfoCmd;
			dicFun[stEliteBarrierCmd.PARA_RET_BARRIER_DATA_CMD] = processRetBarrierDataCmd;
			dicFun[stEliteBarrierCmd.PARA_RET_CUR_BARRIER_CMD] = processRetCurBarrier;
			dicFun[stEliteBarrierCmd.PARA_RET_SLAVEINFO_CMD]  = processRetSlaveInfo;
			dicFun[stEliteBarrierCmd.PARA_TIAOZHAN_RESULT_CMD]  = processTiaoZhanResult;
			dicFun[stEliteBarrierCmd.PARA_LEFT_TIAOZHAN_ONLINE_CMD] = processLeftTiaozhanOnlineCmd;
			dicFun[stEliteBarrierCmd.PARA_REFRESH_BUY_CHALLENGE_TIMES_CMD] = m_gkcontext.m_elitebarrierMgr.process_stRefreshBuyChallengeTimesCmd;*/
			
			dicFun[stEliteBarrierCmd.PARA_NOTIFY_ELITE_BOSS_INFO_CMD] = m_gkcontext.m_elitebarrierMgr.process_stNotifyEliteBossInfoCmd;
			dicFun[stEliteBarrierCmd.PARA_ELITE_BOSS_ONLINE_INFO_CMD] = m_gkcontext.m_elitebarrierMgr.process_stEliteBossOnlineInfoCmd;
		}
		public function process(msg:ByteArray, param:uint):void
		{
			if (dicFun[param] != undefined)
			{
				dicFun[param](msg);
			}
		}
		
		/*public function processRetUIInfoCmd(msg:ByteArray):void
		{			
			var ui:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIBarrierZhenfa);
			if (ui)
			{
				ui.updateData(msg);
				ui.show();
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("uiBarrierZhenfa_uiInfo", msg);
				m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIBarrierZhenfa);
			}
			
		}
		
		public function processRetBarrierDataCmd(msg:ByteArray):void
		{
			var rev:stRetBarrierDataCmd = new stRetBarrierDataCmd();
			rev.deserialize(msg)
			
			if (false == m_gkcontext.m_elitebarrierMgr.m_hasData)
			{
				m_gkcontext.m_elitebarrierMgr.setData(rev);
			}
		}
		
		public function processRetSlaveInfo(msg:ByteArray):void
		{
			var rev:stRetSlaveInfoToClietCmd = new stRetSlaveInfoToClietCmd();
			rev.deserialize(msg);
			var hintParam:Object = new Object();
			hintParam[HintMgr.HINTTYPE]  = HintMgr.HINTTYPE_AddSlave;
			hintParam["slave"] = rev.slavename;
			m_gkcontext.m_hintMgr.hint(hintParam);
		}
		
		public function processRetCurBarrier(msg:ByteArray):void
		{
			var rev:stRetCurBarrierCmd = new stRetCurBarrierCmd();
			rev.deserialize(msg);
			
			m_gkcontext.m_elitebarrierMgr.m_curBarrier = rev.curbarrier;
			m_gkcontext.m_UIMgr.showFormEx(UIFormID.UIEliteBarrier);	
		}
		
		public function processTiaoZhanResult(msg:ByteArray):void
		{
			var form:IUIZhanYiResult = m_gkcontext.m_UIMgr.getForm(UIFormID.UIZhanYiResult) as IUIZhanYiResult;
			if(form)
			{
				form.parseTiaoZhanResult(msg);
			}
			else
			{
				m_gkcontext.m_contentBuffer.addContent("uiZhanYiResult_data", msg);
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIZhanYiResult);
			}
		}
		
		public function processLeftTiaozhanOnlineCmd(msg:ByteArray):void
		{
			var rev:stLeftTiaoZhanOnlineCmd = new stLeftTiaoZhanOnlineCmd();
			rev.deserialize(msg);
			
			m_gkcontext.m_elitebarrierMgr.setLeftTimes(rev.lefttimes);
		}
	*/
	}
}