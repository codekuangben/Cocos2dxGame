package modulecommon.scene.benefithall.peoplerank
{
	/**
	 * ...
	 * @author
	 * 全民冲榜管理器
	 * 7点跨天处理
	 * 等级榜 - 1
	   战力榜 - 2
	   过关斩将榜 - 3
	   组队过关斩将榜 - 4
	 */
	
	import com.util.DebugBox;
	import com.util.UtilCommon;
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.stFixLevelRewardInfo;
	import modulecommon.net.msg.activityCmd.stFixLevelRewardInfoCmd;
	import modulecommon.net.msg.activityCmd.stUpdateFixLevelRewardFlagCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.uiinterface.componentinterface.IPeopleRankPage;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	
	public class PeopleRankMgr implements IBenefitSubSystem
	{
		public static const RANKTYPE_Level:int = 1; //等级榜
		public static const RANKTYPE_Zhanli:int = 2; //战力榜
		public static const RANKTYPE_Guoguan:int = 3; //过关斩将榜
		public static const RANKTYPE_TeamGuoguan:int = 4; //组队过关斩将榜/组队boss
		public static const RANKTYPE_Arena:int = 5; //竞技场
		public static const RANKTYPE_JunTuan:int = 6; //军团战力
		public static const RANKTYPE_Recharge:int = 7; //充值排行
		
		private var m_gkContext:GkContext;
		private var m_dic7Days:Dictionary; //[day, Ranks_Style1]
		
		private var m_dicFixAwards:Dictionary; //[day, stFixLevelRewardInfo]
		private var m_dicDayTo3Days:Dictionary;
		public var m_page:IPeopleRankPage;
		
		public function PeopleRankMgr(gk:GkContext)
		{
			m_gkContext = gk;
			
			m_dicDayTo3Days = new Dictionary();
			m_dicDayTo3Days[1] = [1, 2, 3];
			m_dicDayTo3Days[2] = [1, 2, 3];
			m_dicDayTo3Days[3] = [2, 3, 4];
			m_dicDayTo3Days[4] = [3, 4, 5];
			m_dicDayTo3Days[5] = [4, 5, 6];
			m_dicDayTo3Days[6] = [5, 6, 7];
			m_dicDayTo3Days[7] = [5, 6, 7];
			m_dicDayTo3Days[8] = [5, 6, 7];
		}
		
		public function loadconfig():void
		{
			if (m_dic7Days != null)
			{
				return;
			}
			m_dic7Days = new Dictionary();
			var itemData:Ranks_Style1;
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Rankreward);
			var xmlList:XMLList = UtilXML.getAllChildXmlList(xml);
			var itemXml:XML;
			for each (itemXml in xmlList)
			{
				itemData = new Ranks_Style1();
				itemData.parseXml(itemXml);
				m_dic7Days[itemData.m_day] = itemData;
			}
		}
		
		public function process_stFixLevelRewardInfoCmd(msg:ByteArray, param:uint):void
		{
			var rev:stFixLevelRewardInfoCmd = new stFixLevelRewardInfoCmd();
			rev.deserialize(msg);
			m_dicFixAwards = rev.m_dic;
			
			if (m_gkContext.m_context.m_LoginMgr.m_receivesynOnlineFinDataUserCmd>0)
			{
				DebugBox.info("stFixLevelRewardInfoCmd晚于synOnlineFinDataUserCmd");
			}
		}
		
		public function process_stUpdateFixLevelRewardFlagCmd(msg:ByteArray, param:uint):void
		{
			var rev:stUpdateFixLevelRewardFlagCmd = new stUpdateFixLevelRewardFlagCmd();
			rev.deserialize(msg);
			var item:stFixLevelRewardInfo = getFixAwardsByDay(rev.day);
			if (item)
			{
				item.m_rewardflag = rev.rewardflag;
			}
			
			if (m_page)
			{
				m_page.onLingqu(rev.day);
			}
			
			if (false == hasReward(BenefitHallMgr.BUTTON_Quanminchongbang))
			{
				notify_noReward(BenefitHallMgr.BUTTON_Quanminchongbang);
			}
		}
		
		public function getFixAwardsByDay(day:int):stFixLevelRewardInfo
		{
			if (m_dicFixAwards == null)
			{
				return null;
			}
			return m_dicFixAwards[day];
		}
		
		public function isLingqu(day:int, id:int):Boolean
		{
			var item:stFixLevelRewardInfo = getFixAwardsByDay(day);
			if (item)
			{
				return UtilCommon.isSetUint(item.m_rewardflag, id);
			}
			return false;
		}
		
		public function getHistoryValue(day:int):int
		{
			var item:stFixLevelRewardInfo = getFixAwardsByDay(day);
			if (item)
			{
				if (item.m_day < m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7)
				{
					return item.m_level;
				}
			}
			
			var ret:int;
			var ranksBase:RanksBase = getRanksBaseByDay(day);
			if (ranksBase == null)
			{
				return 0;
			}
			ret = getCurValueByType(ranksBase.m_type);
			return ret;
		}
		
		public function getCurValueByType(type):int
		{
			var ret:int;
			switch (type)
			{
				case RANKTYPE_Level: 
					ret = m_gkContext.playerMain.level;
					break;
				case RANKTYPE_Zhanli: 
					ret = m_gkContext.playerMain.wuProperty.m_uZongZhanli;
					break;
				case RANKTYPE_Guoguan: 
					ret = m_gkContext.m_ggzjMgr.historylayer;
					break;
				case RANKTYPE_TeamGuoguan: 
					ret = m_gkContext.m_teamFBSys.count-1;
					break;
			}
			
			return ret;
		}
		
		//判断在第day天，是否有固定奖励可以领取
		public function hasFixRewardInDay(day:int):Boolean
		{
			if (day == 3 || day == 6 || day == 7)
			{
				return false;
			}
			var rankBase:Ranks_Style1 = getRanksBaseByDay(day) as Ranks_Style1;
			var historyValue:int = getHistoryValue(day);
			if (rankBase)
			{
				var rewardItem:FixReward;
				for each (rewardItem in rankBase.m_fixRwards)
				{
					if (isLingqu(day, rewardItem.m_id))
					{
						continue;
					}
					if (rewardItem.m_level <= historyValue)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function getRanksBaseByDay(day:int):RanksBase
		{
			if (m_dic7Days == null)
			{
				loadconfig();
			}
			return m_dic7Days[day];
		}
		
		//在调用此函数的地方，需要先调用: m_gkcontext.m_timeMgr.process7ClockUserCmd();
		public function process7ClockUserCmd():void
		{
			var day:int = m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			if (day <= 7 && m_dicFixAwards)
			{
				var item:stFixLevelRewardInfo = new stFixLevelRewardInfo();
				item.m_day = m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
				m_dicFixAwards[day] = item;
				
				if (day >= 2)
				{
					item = m_dicFixAwards[day - 1];
					if (item)
					{
						var rankBase:RanksBase = getRanksBaseByDay(item.m_day);
						item.m_level = getCurValueByType(rankBase.m_type);
					}
				}
			}
			
			if (day <= 8)
			{
				if (m_page)
				{
					m_page.onNextDay();
				}
			}
			
			if (m_gkContext.m_benefitHallMgr.hasRewardByID(BenefitHallMgr.BUTTON_Quanminchongbang) == true)
			{
				if (false == hasReward(BenefitHallMgr.BUTTON_Quanminchongbang))
				{
					notify_noReward(BenefitHallMgr.BUTTON_Quanminchongbang);
				}
			}
		}
		
		public function isShowTabBtn():Boolean
		{
			var day:int = m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			return day >= 1 && day <= 8;
		}
		
		public function get3DaysInCurDay(day:int):Array
		{
			return m_dicDayTo3Days[day];
		}
		
		public function hasReward(id:int):Boolean
		{
			var curDay:int = m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			var dayList:Array = get3DaysInCurDay(curDay);
			if (dayList == null)
			{
				return false;
			}
			var day:int;
			
			for each (day in dayList)
			{
				if (day <= curDay)
				{
					if (hasFixRewardInDay(day))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function notify_hasReward(id:int):void
		{
			m_gkContext.m_benefitHallMgr.onNotify_hasReward(id);
		}
		
		public function notify_noReward(id:int):void
		{
			m_gkContext.m_benefitHallMgr.onNotify_noReward(id);
		}
		
		public function onValueUp(type:int):void
		{
			if (m_gkContext.m_benefitHallMgr.isInit == false)
			{
				return;
			}
			var curDay:int = m_gkContext.m_context.m_timeMgr.dayOfOpenServer_7;
			var dayList:Array = get3DaysInCurDay(curDay);
			if (dayList == null)
			{
				return;
			}
			
			if (m_gkContext.m_benefitHallMgr.hasRewardByID(BenefitHallMgr.BUTTON_Quanminchongbang))
			{
				return;
			}
			var day:int;
			
			var rankBase:RanksBase;
			var dayRelativeToType:int = 0;
			for each (day in dayList)
			{
				if (day <= curDay)
				{
					rankBase = getRanksBaseByDay(day);
					if (rankBase && rankBase.m_type == type)
					{
						dayRelativeToType = day;
						break;
					}
				}
			}
			
			if (dayRelativeToType)
			{
				if (hasFixRewardInDay(day))
				{
					notify_hasReward(BenefitHallMgr.BUTTON_Quanminchongbang);
				}
				else
				{
					notify_noReward(BenefitHallMgr.BUTTON_Quanminchongbang);
				}
			}
		}
	}

}