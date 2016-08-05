package game.netcb 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.process.MountsProcess;
	import game.process.PaoShangProcess;
	import game.process.RankProcess;
	import game.process.SanguoZhanchangProcess;
	import game.process.SGQunYingCmdProcess;
	import game.process.WorldBossProcess;
	import game.process.WuNvProcess;
	import game.process.ZhanxingProcess;
	import game.ui.uiScreenBtn.subcom.SGQunyinghui;
	
	import common.net.msg.basemsg.stNullUserCmd;
	
	import game.process.ActivityProcess;
	import game.process.ArenaProcess;
	import game.process.ChatProcess;
	import game.process.CorpsProcess;
	import game.process.EliteBarrierProcess;
	import game.process.EquipProcess;
	import game.process.FightProcess;
	import game.process.FndProcess;
	import game.process.FubenProcess;
	import game.process.GiftProcess;
	import game.process.GuoguanzhanjiangProcess;
	import game.process.HeroProcess;
	import game.process.MailProcess;
	import game.process.PropertyUserProcess;
	import game.process.SceneUserProcess;
	import game.process.ShoppingProcess;
	import game.process.TeamProcess;
	import game.process.XingmaiProcess;
	
	import modulecommon.GkContext;
	import net.IGameNetHandle;
	import modulecommon.net.MessageBuffer;
	//import common.net.endata.EnNet;
	/**
	 * ...
	 */
	public class GameNetHandle implements IGameNetHandle 
	{
		private var m_cache:MessageBuffer;
		public var m_regfunc:Dictionary;
		public var m_gkcontext:GkContext;
		private var m_sceneUserProcess:SceneUserProcess;
		private var m_fightProcess:FightProcess;
		private var m_chatProcess:ChatProcess;
		private var m_fubenProcess:FubenProcess;
		private var m_propertyUserProcess:PropertyUserProcess;
		private var m_heroProcess:HeroProcess;	//武将消息处理模块
		private var m_xingmaiProcess:XingmaiProcess;
		private var m_activityProcess:ActivityProcess;
		private var m_equipProcess:EquipProcess;
		private var m_eliteBarrierProcess:EliteBarrierProcess;
		private var m_mailProcess:MailProcess;
		private var m_arenaProcess:ArenaProcess;
		private var m_guoguanzhanjiangProcess:GuoguanzhanjiangProcess;
		private var m_giftProcess:GiftProcess;
		private var m_corpsProcess:CorpsProcess;
		private var m_fndProcess:FndProcess;
		private var m_shoppingProcess:ShoppingProcess;
		private var m_teamProcess:TeamProcess;
		private var m_sanguoZhanchangProcess:SanguoZhanchangProcess;
		private var m_zhanxingProcess:ZhanxingProcess;
		private var m_worldbossProcess:WorldBossProcess;
		private var m_wunvProcess:WuNvProcess;
		private var m_mountsProcess:MountsProcess;
		private var m_rankProcess:RankProcess;
		private var m_sgQunYingCmdProcess:SGQunYingCmdProcess;
		private var m_paoShangCmdProcess:PaoShangProcess;
		
		public function GameNetHandle(cont:GkContext):void
		{
			m_cache = new MessageBuffer();
			m_gkcontext = cont;
			m_sceneUserProcess = new SceneUserProcess(m_gkcontext);
			m_fightProcess = new FightProcess(m_gkcontext);
			m_chatProcess = new ChatProcess(m_gkcontext);
			m_fubenProcess = new FubenProcess(m_gkcontext);
			m_propertyUserProcess = new PropertyUserProcess(m_gkcontext);
			m_heroProcess = new HeroProcess(m_gkcontext);
			m_xingmaiProcess = new XingmaiProcess(m_gkcontext);
			m_activityProcess = new ActivityProcess(m_gkcontext);
			m_equipProcess = new EquipProcess(m_gkcontext);
			m_eliteBarrierProcess = new EliteBarrierProcess(m_gkcontext);
			m_mailProcess = new MailProcess(m_gkcontext);
			m_arenaProcess = new ArenaProcess(m_gkcontext);
			m_guoguanzhanjiangProcess = new GuoguanzhanjiangProcess(m_gkcontext);
			m_giftProcess = new GiftProcess(m_gkcontext);
			m_corpsProcess = new CorpsProcess(m_gkcontext);
			m_fndProcess = new FndProcess(m_gkcontext);
			m_shoppingProcess = new ShoppingProcess(m_gkcontext);
			m_teamProcess = new TeamProcess(m_gkcontext);
			m_sanguoZhanchangProcess = new SanguoZhanchangProcess(m_gkcontext);
			m_zhanxingProcess = new ZhanxingProcess(m_gkcontext);
			m_worldbossProcess = new WorldBossProcess(m_gkcontext);
			m_wunvProcess = new WuNvProcess(m_gkcontext);
			m_mountsProcess = new MountsProcess(m_gkcontext);
			m_rankProcess = new RankProcess(m_gkcontext);
			m_sgQunYingCmdProcess = new SGQunYingCmdProcess(m_gkcontext);
			m_paoShangCmdProcess = new PaoShangProcess(m_gkcontext);
			
			m_regfunc = new Dictionary();
			m_regfunc[stNullUserCmd.SCENE_USERCMD] = m_sceneUserProcess.processSceneUserCmd;
			m_regfunc[stNullUserCmd.SCENEPK_CMD] = m_fightProcess.processFightCmd;
			m_regfunc[stNullUserCmd.TASK_USERCMD] = m_gkcontext.m_taskMgr.handleMsg;
			m_regfunc[stNullUserCmd.CHAT_USERCMD] = m_chatProcess.process;
			m_regfunc[stNullUserCmd.COPY_USERCMD] = m_fubenProcess.process;
			m_regfunc[stNullUserCmd.PROPERTY_USERCMD] = m_propertyUserProcess.process;
			m_regfunc[stNullUserCmd.HERO_USERCMD] = m_heroProcess.process;
			m_regfunc[stNullUserCmd.XINGMAI_USERCMD] = m_xingmaiProcess.process;
			m_regfunc[stNullUserCmd.ACTIVITY_USERCMD] = m_activityProcess.process;
			m_regfunc[stNullUserCmd.REMAKEEQUIP_USERCMD] = m_equipProcess.process;
			m_regfunc[stNullUserCmd.ELITE_BARRIER_CMD] = m_eliteBarrierProcess.process;
			m_regfunc[stNullUserCmd.MAIL_USERCMD] = m_mailProcess.process;
			m_regfunc[stNullUserCmd.GUANZHI_USERCMD] = m_arenaProcess.process;
			m_regfunc[stNullUserCmd.TRIALTOWER_USERCMD] = m_guoguanzhanjiangProcess.process;
			m_regfunc[stNullUserCmd.GIFT_USERCMD] = m_giftProcess.process;
			m_regfunc[stNullUserCmd.CORPS_USERCMD] = m_corpsProcess.process;
			m_regfunc[stNullUserCmd.FRIEND_USERCMD] = m_fndProcess.process;
			m_regfunc[stNullUserCmd.SHOPPING_USERCMD] = m_shoppingProcess.process;
			m_regfunc[stNullUserCmd.TEAM_USERCMD] = m_teamProcess.process;
			m_regfunc[stNullUserCmd.RESROB_USERCMD] = m_sanguoZhanchangProcess.process;
			m_regfunc[stNullUserCmd.ZHANXING_USERCMD] = m_zhanxingProcess.process;
			m_regfunc[stNullUserCmd.WORLDBOSS_USERCMD] = m_worldbossProcess.process;
			m_regfunc[stNullUserCmd.WUNV_USERCMD] = m_wunvProcess.process;
			m_regfunc[stNullUserCmd.MOUNT_USERCMD] = m_mountsProcess.process;
			m_regfunc[stNullUserCmd.RANK_USERCMD] = m_rankProcess.process;
			m_regfunc[stNullUserCmd.SGQUNYINGHUI_USERCMD] = m_sgQunYingCmdProcess.process;
			m_regfunc[stNullUserCmd.BUSINESS_USERCMD] = m_paoShangCmdProcess.process;
		}
		
		public function destroy():void
		{
			var key:String;
			for (key in m_regfunc)
			{
				m_regfunc[key] = null;
				delete m_regfunc[key];
			}
			
			m_regfunc = null;
		}
		
		public function handleMsg(msg:ByteArray, cmd:uint = 0, param:uint = 0):void
		{
			if (m_cache.isInBufferState == true)
			{
				m_cache.pushTwoParam(msg, cmd, param);
				return;
			}
			if (m_regfunc[cmd])
			{
				m_regfunc[cmd](msg, param);
			}
		}
		
		public function cacheMsg():void
		{
			m_cache.isInBufferState = true;
		}
		public function unCacheMsg():void
		{
			m_cache.isInBufferState = false;
			m_cache.executeTwoParam(handleMsg);
		}
		
		public function simulationMsg(msg:ByteArray, param:uint):void
		{
			m_fightProcess.processFightCmd(msg, param,false);
		}
	}
}