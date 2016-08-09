package game.process 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.zhanXingCmd.stZhanXingCmd;
	import modulecommon.scene.zhanxing.ZhanxingMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ZhanxingProcess extends ProcessBase 
	{		
		public function ZhanxingProcess(gk:GkContext)
		{
			super(gk);
			
			var mgr:ZhanxingMgr = m_gkContext.m_zhanxingMgr;
			dicFun[stZhanXingCmd.PARA_ZHAN_XING_INFO_ZXCMD] = mgr.process_stZhanXingInfoCmd;
			dicFun[stZhanXingCmd.PARA_ALL_SHENBING_INFO_ZXCMD] = mgr.process_stAllShenBingInfoCmd;
			dicFun[stZhanXingCmd.PARA_REFRESH_SILVER_VISIT_TIMES_WUXUE_CMD] = mgr.process_stRefreshSilverVisitTimesWuXueCmd;
			dicFun[stZhanXingCmd.PARA_LIGHT_HERO_ZXCMD] = mgr.process_stLightHeroCmd;
			dicFun[stZhanXingCmd.PARA_REFRESH_ZXSCORE_ZXCMD] = mgr.process_stRefreshZXScoreCmd;
			dicFun[stZhanXingCmd.PARA_ADD_SHENBING_ZXCMD] = mgr.process_stAddShenBingCmd;
			dicFun[stZhanXingCmd.PARA_REMOVE_SHENBING_ZXCMD] = mgr.process_stRemoveShenBingCmd;
			dicFun[stZhanXingCmd.PARA_SWAP_SHENBING_ZXCMD] = mgr.process_stSwapShenBingCmd;
			
			dicFun[stZhanXingCmd.PARA_REFRESH_OPENED_GEZI_NUM_ZXCMD] = mgr.process_stRefreshOpenedGeZiNumCmd;
			dicFun[stZhanXingCmd.PARA_REFRESH_MINGLI_ZXCMD] = mgr.process_stRefreshMingLiCmd;
			dicFun[stZhanXingCmd.PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD] = mgr.process_stViewOtherUserEquipedWuxueCmd;
			dicFun[stZhanXingCmd.GM_PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD] = gk.m_gmWatchMgr.processstGmViewOtherUserEquipedWuXueCmd;
		}
		
	}

}