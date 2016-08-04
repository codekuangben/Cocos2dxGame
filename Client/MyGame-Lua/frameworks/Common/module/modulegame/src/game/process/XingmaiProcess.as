package game.process 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.xingMaiCmd.stXingMaiCmd;
	import modulecommon.scene.xingmai.XingmaiMgr;
	/**
	 * ...
	 * @author 
	 * 星脉功能
	 */
	
	public class XingmaiProcess extends ProcessBase
	{
		private var m_xmMgr:XingmaiMgr;
		
		public function XingmaiProcess(gk:GkContext) 
		{
			super(gk);
			
			m_xmMgr = m_gkContext.m_xingmaiMgr;
			dicFun[stXingMaiCmd.PARA_XINGMAI_UIINFO_XMCMD] = m_xmMgr.processXingmaiUIinfoXMCmd;
			dicFun[stXingMaiCmd.PARA_LEVELUP_XMATTR_XMCMD] = m_xmMgr.processLevelUpXMAttrXMCmd;
			dicFun[stXingMaiCmd.PARA_NOTIFY_XMSKILL_ACTIVE_XMCMD] = m_xmMgr.processNotifyXMSkillActiveXMCmd;
			dicFun[stXingMaiCmd.PARA_CHANGE_USERSKILL_XMCMD] = m_xmMgr.processChangeUserSkillXMCmd;
			dicFun[stXingMaiCmd.PARA_LEVELUP_XMSKILL_XMCMD] = m_xmMgr.processLevelUpXMSkillXMCmd;
			dicFun[stXingMaiCmd.PARA_XINGLI_CHANGE_XMCMD] = m_xmMgr.processXingmaiChangeXMCmd;
		}
	}

}