package game.process 
{
	import flash.utils.ByteArray;
	import game.ui.herorally.UIHeroRally;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.stSGQunYingCmd;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class SGQunYingCmdProcess extends ProcessBase 
	{
		
		public function SGQunYingCmdProcess(gk:GkContext) 
		{
			super(gk);
			dicFun[stSGQunYingCmd.PARA_NOTIFY_CROSS_SERVER_ISREADY_CMD] = m_gkContext.process_stNotifyCrossServerIsReadyCmd;
			dicFun[stSGQunYingCmd.PARA_QUNYINGHUI_ONLINE_CMD] = m_gkContext.m_heroRallyMgr.process_stQunYingHuiOnlineCmd;
			dicFun[stSGQunYingCmd.PARA_MATCH_USER_INFO_CMD] = m_gkContext.m_heroRallyMgr.process_stMatchUserInfoCmd;
			dicFun[stSGQunYingCmd.PARA_UPDATE_USER_INFO_CMD] = m_gkContext.m_heroRallyMgr.process_stUpdateUserInfoCmd;
			dicFun[stSGQunYingCmd.PARA_UPDATE_USER_ZHANJI_CMD] = m_gkContext.m_heroRallyMgr.process_stUpdateUserZhanJiCmd;
			dicFun[stSGQunYingCmd.PARA_GET_VIC_BOX_CMD] = m_gkContext.m_heroRallyMgr.process_stGetVicBoxCmd;
			dicFun[stSGQunYingCmd.PARA_RET_QUN_YING_HUI_RANK_CMD] = processStGetVicBoxCmd;
		}
		public function processStGetVicBoxCmd(byte:ByteArray, param:uint):void
		{
			var form:UIHeroRally = m_gkContext.m_UIMgr.getForm(UIFormID.UIHeroRally) as UIHeroRally;
			if(form)
			{
				form.processCmd(byte,param);
			}
		}
	}

}