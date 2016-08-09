package modulecommon.scene.taskprompt 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.Item;
	import modulecommon.scene.ingotbefall.IngotBefallMgr;
	import modulecommon.scene.worldboss.WorldBossMgr;
	
	import modulecommon.scene.cangbaoku.CangbaokuMgr;
	import modulecommon.scene.arena.ArenaMgr;
	import modulecommon.scene.elitebarrier.EliteBarrierMgr;
	import modulecommon.scene.task.TaskManager;
	import modulecommon.scene.jiuguan.JiuguanMgr;
	/**
	 * ...
	 * @author 今日推荐功能
	 */
	public class TaskPromptMgr 
	{
		//以下赋值同配置文件common.xml中对应编号
		public static const TASKPROMPT_Action:int = 0;				//活跃度值
		public static const TASKPROMPT_EquipStren:int = 1;			//强化
		public static const TASKPROMPT_Cangbaoku:int = 2;			//藏宝库
		public static const TASKPROMPT_Arena:int = 3;				//竞技场
		public static const TASKPROMPT_EliteBarrier:int = 4;		//精英boss
		public static const TASKPROMPT_XuanshangRenwu:int = 5;		//悬赏任务
		public static const TASKPROMPT_SnatchTreasure:int = 6;		//宝物抢夺
		public static const TASKPROMPT_Gamble:int = 7;				//赌博
		public static const TASKPROMPT_IngotBefall:int = 8;			//财神降临
		public static const TASKPROMPT_TRIALTOWER:int = 9;			//过关斩将
		public static const TASKPROMPT_CorpsTask:int = 10;			//军团任务
		public static const TASKPROMPT_TeamFBSys:int = 11;			//组队副本
		public static const TASKPROMPT_WorldBoss:int = 12;			//世界Boss
		public static const TASKPROMPT_SanguoZhanchang:int = 13;	//三国战场
		public static const TASKPROMPT_GodlyWeaponTrain:int = 14;	//神兵培养
		public static const TASKPROMPT_MAX:int = 15;
		
		public var m_gkContext:GkContext;
		public var m_list:Array;
		public var m_bLoadConfig:Boolean;
		
		public function TaskPromptMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_list = new Array();
			m_bLoadConfig = false;
		}
		
		//从common.xml配置文件中，读取相关数据:推荐度 奖励描述
		private function loadConfig():void
		{
			var xml:XML = m_gkContext.m_commonXML.getItem(1);
			parseXml(xml);
			
			if (m_list.length)
			{
				m_bLoadConfig = true;
				m_gkContext.m_commonXML.deleteItem(1);
			}
		}
		
		private function parseXml(xml:XML):void
		{
			var taskpromptitem:TaskPromptItem;
			var itemList:XMLList = xml.child("item");
			
			for each(var item:XML in itemList)
			{
				taskpromptitem = new TaskPromptItem();
				taskpromptitem.parseXml(item);
				m_list.push(taskpromptitem);
			}
			
			m_list.sort(compar);
		}
		
		//按照推荐度排序，从大到小
		private function compar(a:TaskPromptItem, b:TaskPromptItem):int
		{
			if (a.m_recommendLevel >= b.m_recommendLevel)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function initData():void
		{
			if (false == m_bLoadConfig)
			{
				loadConfig();
			}
			
			m_gkContext.m_dailyActMgr.loadConfig();
			
			updateDatas();
		}
		
		//更新冷却时间/剩余次数
		public function updateDatas():void
		{
			for each(var item:TaskPromptItem in m_list)
			{
				setColdTimesAddCounts(item);
			}
		}
		
		public function isShowUITaskPrompt():Boolean
		{
			var i:int;
			var funcid:int;
			for (i = 1; i < TASKPROMPT_MAX; i++)
			{
				if (i == TASKPROMPT_CorpsTask)
				{
					if (m_gkContext.m_corpsMgr.hasCorps)
					{
						return true;
					}
				}
				else
				{
					funcid = getFuncID(i);
					if (m_gkContext.m_sysnewfeatures.isSet(funcid))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function setColdTimesAddCounts(item:TaskPromptItem):void
		{
			var id:int = item.m_ID;
			var countMax:uint = 0;
			var curCounts:uint = 0;
			switch(id)
			{
				case TASKPROMPT_Action:
					countMax = m_gkContext.m_dailyActMgr.getNextActRewardFen();
					curCounts = m_gkContext.m_dailyActMgr.m_actValue;
					break;
				case TASKPROMPT_EquipStren:
					break;
				case TASKPROMPT_Cangbaoku:
					countMax = m_gkContext.m_cangbaokuMgr.curTanbaoMaxTimes;
					curCounts = m_gkContext.m_cangbaokuMgr.remainedTimes;
					break;
				case TASKPROMPT_Arena:
					countMax = ArenaMgr.PKMAXCOUNT;
					curCounts = countMax - m_gkContext.m_arenaMgr.pkCount;
					break;
				case TASKPROMPT_EliteBarrier:
					countMax = EliteBarrierMgr.JBOSS_MAXCOUNTS;
					curCounts = m_gkContext.m_elitebarrierMgr.m_lfBossNum;
					break;
				case TASKPROMPT_XuanshangRenwu:
					countMax = TaskManager.XUANSHANG_MAXCOUNT;
					curCounts = countMax - m_gkContext.m_taskMgr.receivedCount;
					break;
				case TASKPROMPT_SnatchTreasure:
					countMax = JiuguanMgr.ROB_MAXCOUNTS;
					curCounts = m_gkContext.m_jiuguanMgr.m_robLeftTimes;
					break;
				case TASKPROMPT_Gamble:
					countMax = m_gkContext.m_gambleMgr.m_maxFree;
					curCounts = m_gkContext.m_gambleMgr.m_leftFrees;
					break;
				case TASKPROMPT_IngotBefall:
					countMax = IngotBefallMgr.INGOTBEFALL_FREETIMES;
					curCounts = m_gkContext.m_ingotbefallMgr.leftFrees;
					break;
				case TASKPROMPT_TRIALTOWER:
					countMax = 1;
					curCounts = m_gkContext.m_ggzjMgr.m_timeChallenge;
					break;
				case TASKPROMPT_CorpsTask:
					countMax = m_gkContext.m_corpsMgr.m_taskMaxCounts;
					curCounts = countMax - m_gkContext.m_corpsMgr.m_taskCounts;
					break;
				case TASKPROMPT_TeamFBSys:
					countMax = m_gkContext.m_teamFBSys.maxCountsFight;
					curCounts = m_gkContext.m_teamFBSys.leftCounts;
					break;
				case TASKPROMPT_WorldBoss:
					countMax = WorldBossMgr.MAXCOUNTS_JOIN;
					curCounts = m_gkContext.m_worldBossMgr.leftJoinTimes;
					break;
				case TASKPROMPT_SanguoZhanchang:
					countMax = m_gkContext.m_sanguozhanchangMgr.maxTimes;
					curCounts = m_gkContext.m_sanguozhanchangMgr.timesOfReward;
					break;
				case TASKPROMPT_GodlyWeaponTrain:
					countMax = m_gkContext.m_godlyWeaponMgr.m_maxTrainTimes;
					curCounts = m_gkContext.m_godlyWeaponMgr.m_leftTrainTimes;
					break;
			}
			
			item.m_countsMax = countMax;
			item.m_curCounts = curCounts;
		}
		
		public static function getFuncID(id:int):int
		{
			var ret:int;
			switch(id)
			{
				case TASKPROMPT_EquipStren:
					ret = SysNewFeatures.NFT_DAZAO;
					break;
				case TASKPROMPT_Cangbaoku:
					ret = SysNewFeatures.NFT_CANBAOKU;
					break;
				case TASKPROMPT_Arena:
					ret = SysNewFeatures.NFT_JINGJICHANG;
					break;
				case TASKPROMPT_EliteBarrier:
					ret = SysNewFeatures.NFT_ZHANYITIAOZHAN;
					break;
				case TASKPROMPT_XuanshangRenwu:
					ret = SysNewFeatures.NFT_XUANSHANG;
					break;
				case TASKPROMPT_SnatchTreasure:
					ret = SysNewFeatures.FUNC_JIUGUANPURPLE;
					break;
				case TASKPROMPT_Gamble:
					ret = SysNewFeatures.FUNC_GAMBLE;
					break;
				case TASKPROMPT_IngotBefall:
					ret = SysNewFeatures.NFT_CAISHENDAO;
					break;
				case TASKPROMPT_TRIALTOWER:
					ret = SysNewFeatures.NFT_TRIALTOWER;
					break;
				case TASKPROMPT_CorpsTask:
					ret = SysNewFeatures.NFT_JUNTUAN;
					break;
				case TASKPROMPT_TeamFBSys:
					ret = SysNewFeatures.NFT_TEAMCOPY;
					break;
				case TASKPROMPT_WorldBoss:
					ret = SysNewFeatures.NFT_WORLDBOSS;
					break;
				case TASKPROMPT_SanguoZhanchang:
					ret = SysNewFeatures.NFT_SANGUOZHANCHANG;
					break;
				case TASKPROMPT_GodlyWeaponTrain:
					ret = SysNewFeatures.FUNC_GWSkillTrain;
					break;
				default:
					ret = 0;
			}
			
			return ret;
		}
		
		//获得所有将要显示的推荐功能
		public function getAllShowPrompts():Array
		{
			var ret:Array;
			if (m_list.length)
			{
				var item:TaskPromptItem;
				ret = new Array();
				
				if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_WELFAREHALL))
				{
					item = new TaskPromptItem();
					item.m_ID = TASKPROMPT_Action;
					item.m_name = "活跃度值";
					item.m_curCounts = m_gkContext.m_dailyActMgr.m_actValue;
					item.m_countsMax = m_gkContext.m_dailyActMgr.getNextActRewardFen();
					ret.push(item);
				}
				
				for each(item in m_list)
				{
					if (isShowPromptItem(item))
					{
						ret.push(item);
					}
				}
			}
			return ret;
		}
		
		//判断是否需要显示 true:显示  false:不显示
		public function isShowPromptItem(item:TaskPromptItem):Boolean
		{
			var funcId:int = getFuncID(item.m_ID);
			
			if (TASKPROMPT_CorpsTask == item.m_ID)//军团任务在加入军团后显示
			{
				if (m_gkContext.m_corpsMgr.hasCorps && (item.m_curCounts > 0))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			
			if (m_gkContext.m_sysnewfeatures.isSet(funcId))
			{
				if (TASKPROMPT_SnatchTreasure == item.m_ID && !m_gkContext.m_jiuguanMgr.isPurpleWuOpen)
				{
					return false;
				}
				
				//今日次数已用完
				if (0 == item.m_curCounts && item.m_countsMax > 0)
				{
					return false;
				}
				
				return true;
			}
			
			return false;
		}
		
		public function getImageName(id:int):String
		{
			var ret:String;
			switch(id)
			{
				case TASKPROMPT_EquipStren:
					ret = "star";
					break;
				case TASKPROMPT_Cangbaoku:
					ret = "gem";
					break;
				case TASKPROMPT_Arena:
					ret = "arena";
					break;
				case TASKPROMPT_EliteBarrier:
					ret = "fight";
					break;
				case TASKPROMPT_XuanshangRenwu:
					ret = "star";
					break;
				case TASKPROMPT_SnatchTreasure:
					ret = "rob";
					break;
				case TASKPROMPT_Gamble:
					ret = "star";
					break;
				case TASKPROMPT_IngotBefall:
					ret = "star";
					break;
				case TASKPROMPT_TRIALTOWER:
					ret = "gem";
					break;
				case TASKPROMPT_CorpsTask:
					ret = "star";
					break;
				case TASKPROMPT_TeamFBSys:
					ret = "star";
					break;
				case TASKPROMPT_WorldBoss:
					ret = "fight";
					break;
				case TASKPROMPT_SanguoZhanchang:
					ret = "fight";
					break;
				case TASKPROMPT_GodlyWeaponTrain:
					ret = "star";
					break;
				default:
					ret = "";
			}
			
			return ret;
		}
	}

}