package game.process 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.worldbossCmd.stWorldBossCmd;
	import modulecommon.scene.worldboss.WorldBossMgr;
	/**
	 * ...
	 * @author ...
	 * 世界BOSS
	 */
	public class WorldBossProcess extends ProcessBase
	{
		
		public function WorldBossProcess(gk:GkContext)
		{
			super(gk);
			
			var mgr:WorldBossMgr = m_gkContext.m_worldBossMgr;
			dicFun[stWorldBossCmd.PARA_NOTIFY_ACT_STATE_WBCMD] = mgr.processNotifyActStateWbCmd;
			dicFun[stWorldBossCmd.PARA_NOTIFY_ACT_WAITTIME_WBCMD] = mgr.processNotifyActWaittimeWbCmd;
			dicFun[stWorldBossCmd.PARA_NOTIFY_BOSS_INFO_WBCMD] = mgr.processNotifyBossInfoWbCmd;
			dicFun[stWorldBossCmd.PARA_NOTIFY_RANKLIST_INFO_WBCMD] = mgr.processNotifyRanklistInfoWbCmd;
			dicFun[stWorldBossCmd.PARA_NOTIFY_RELIVE_TIME_WBCMD] = mgr.processNotifyReliveTimeWbCmd;
			dicFun[stWorldBossCmd.PARA_INSPIRE_LEFTTIMES_WBCMD] = mgr.processInspireLefttimesWbCmd;
			dicFun[stWorldBossCmd.PARA_ENCOURAGE_LEFTTIMES_WBCMD] = mgr.processEncourageLefttimesWbCmd;
			dicFun[stWorldBossCmd.PARA_FIGHTRESULT_INFO_WBCMD] = mgr.processFightResultInfoWbCmd;
			dicFun[stWorldBossCmd.PARA_JOIN_WORLD_BOSS_TIMES_WBCMD] = mgr.processJoinWorldbossTimesWbCmd;
			dicFun[stWorldBossCmd.PARA_NOTIFY_BOSS_HPINFO_WBCMD] = mgr.processNotifyBossHpInfoWbCmd;
			dicFun[stWorldBossCmd.PARA_BOSS_POSITION_INFO_WBCMD] = mgr.processBossPositionInfoWbCmd;
		}
		
	}

}