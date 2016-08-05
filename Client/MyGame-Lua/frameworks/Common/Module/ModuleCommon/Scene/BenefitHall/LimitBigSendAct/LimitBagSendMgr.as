package modulecommon.scene.benefithall.LimitBigSendAct 
{
	/**
	 * ...
	 * @author 
	 * 限时礼包放送功能
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.stLimitBigSendActInfoCmd;
	import modulecommon.net.msg.activityCmd.stLimitBigSendItem;
	import modulecommon.net.msg.activityCmd.stNotifyLimitBigSendActStateCmd;
	import modulecommon.net.msg.activityCmd.stRefreshLBSAItemInfoCmd;
	import modulecommon.net.msg.activityCmd.stRefreshLBSAProgressCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	import time.UtilTime;
	
	public class LimitBagSendMgr implements IBenefitSubSystem
	{
		//public var m_activation:Boolean;//限时放送开启状态 true为开启状态
		private var m_gkContext:GkContext;
		private var m_bLoadConfig:Boolean;//xml加载一次用
		private var m_LimitBigSendItemList:Dictionary;//LimitBigSendItem数组,消息维护动态的
		public var m_LimitBigSendActItemListOfDay:Array;//LimitBigSendActItem数组,xml读取静态的 与上面合并
		private var m_actEndTime:Number;//活动结束时间
		//private var m_TimeofGetLT:Number;
		private var m_startTime:Number;//活动开始时间
		private var m_endTime:Number;//领取结束日期
		public function LimitBagSendMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bLoadConfig = false;
			//m_activation = false;
			m_LimitBigSendItemList = new Dictionary();
			m_actEndTime = -1;
			//m_TimeofGetLT = -1;
			m_startTime = -1;
			m_endTime = -1;
		}
		public function loadconfig():void
		{
			if (m_bLoadConfig)
			{
				return;
			}
			m_LimitBigSendActItemListOfDay = new Array();
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Limitbigsendact);
			var tabXml:XML;
			for each (tabXml in xml.elements("actopen"))
			{
				var item:ItemOfDay = new ItemOfDay();
				item.parse(tabXml);
				m_LimitBigSendActItemListOfDay.push(item);
			}
			m_bLoadConfig = true;
			
		}
		public function process_stLimitBigSendActInfoCmd(byte:ByteArray, param:uint):void //上线初始化
		{
			//m_activation = true;
			var rev:stLimitBigSendActInfoCmd = new stLimitBigSendActInfoCmd();
			rev.deserialize(byte);
			//m_actEndTime = rev.m_endtime;
			m_startTime = rev.m_starttime;
			//m_endTime = rev.m_endtime + rev.m_delay;
			//m_TimeofGetLT = Math.floor(m_gkContext.m_context.m_processManager.platformTime/1000);
			var senditem:stLimitBigSendItem;
			for each(senditem in rev.m_list)
			{
				m_LimitBigSendItemList[senditem.m_actid] = senditem;
			}
		}
		public function process_stRefreshLBSAProgressCmd(byte:ByteArray, param:uint):void //刷新进度
		{
			var rev:stRefreshLBSAProgressCmd = new stRefreshLBSAProgressCmd();
			rev.deserialize(byte);
			var item:stLimitBigSendItem = m_LimitBigSendItemList[rev.m_actid];
			if (item)
			{
				item.m_progress=rev.m_progress
			}
			else
			{
				item = new stLimitBigSendItem();
				item.m_actid = rev.m_actid;
				item.m_progress = rev.m_progress;
				item.m_rewardtimes = 0;
				m_LimitBigSendItemList[rev.m_actid] = item;
			}
			notifyUpdata(rev.m_actid);
			if (m_gkContext.m_benefitHallMgr.hasRewardByID(getPagebyId(rev.m_actid)))
			{
				return;
			}
			if (isReward(getPagebyId(rev.m_actid)))
			{
				notify_hasReward(getPagebyId(rev.m_actid));
			}
		}
		public function process_stRefreshLBSAItemInfoCmd(byte:ByteArray, param:uint):void //刷新进度、兑换次数
		{
			var rev:stRefreshLBSAItemInfoCmd = new stRefreshLBSAItemInfoCmd();
			rev.deserialize(byte);
			m_LimitBigSendItemList[rev.m_data.m_actid] = rev.m_data;
			notifyUpdata(rev.m_data.m_actid);
			if (!isReward(getPagebyId(rev.m_data.m_actid)))
			{
				notify_noReward(getPagebyId(rev.m_data.m_actid));
			}
		}
		public function process_stNotifyLimitBigSendActStateCmd(byte:ByteArray, param:uint):void //通知状态  这条消息服务器会发 客户端没用了 不处理了
		{
			/*var rev:stNotifyLimitBigSendActStateCmd = new stNotifyLimitBigSendActStateCmd();
			rev.deserialize(byte);
			if (rev.m_state == 1)
			{
				m_actEndTime = rev.m_endtime;
				m_startTime = rev.m_starttime;
				m_endTime = rev.m_endtime + rev.m_delay;
				//m_TimeofGetLT = Math.floor(m_gkContext.m_context.m_processManager.platformTime/1000);
				if (m_gkContext.m_UIs.benefitHall)
				{
					m_gkContext.m_UIs.benefitHall.addPage(BenefitHallMgr.BUTTON_XianshiFangsong);
				}
				m_activation = true;
			}
			else if (rev.m_state == 5)
			{
				if (m_gkContext.m_UIs.benefitHall)
				{
					m_gkContext.m_UIs.benefitHall.removePage(BenefitHallMgr.BUTTON_XianshiFangsong);
				}
				m_activation = false;
			}*/
		}
		private function notifyUpdata(id:uint):void
		{
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.updateDataOnePage(getPagebyId(id), id);
			}
		}
		private function getPagebyId(id:uint):int
		{
			for each(var item:ItemOfDay in m_LimitBigSendActItemListOfDay)
			{
				for each(var etem:LimitBigSendActItem in item.m_LimitBigSendActItemList)
				{
					if (etem.m_id == id)
					{
						return BenefitHallMgr.BUTTON_XianshiFangsong1 + m_LimitBigSendActItemListOfDay.indexOf(item);
					}
				}
			}
			return 0;
		}
		public function leftTime(pageid:int):Number
		{
			var endday:uint = (m_LimitBigSendActItemListOfDay[pageid] as ItemOfDay).m_end;
			var t:Number = UtilTime.s_curDay_7(m_startTime + endday * 3600*24) - m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond();
			if (t > 0)
			{
				return t;
			}
			return 0;
		}
		public function startTime(pageid:int):Number
		{
			var startday:uint = (m_LimitBigSendActItemListOfDay[pageid] as ItemOfDay).m_begin;
			if (startday == 1)
			{
				return m_startTime;
			}
			return UtilTime.s_curDay_7(m_startTime+(startday-1)*3600*24);
		}
		public function endTime(pageid:int):Number
		{
			var endday:uint = (m_LimitBigSendActItemListOfDay[pageid] as ItemOfDay).m_end;
			return UtilTime.s_curDay_7(m_startTime + (endday + 1) * 3600*24);
		}
		public function LimitBigSendItemList(id:uint):stLimitBigSendItem
		{
			return m_LimitBigSendItemList[id];
		}
		
		public function hasReward(id:int):Boolean//////////////////////////////
		{
			loadconfig();
			if (!isact(id - BenefitHallMgr.BUTTON_XianshiFangsong1))
			{
				return false;
			}
			return isReward(id);
		}
		private function isReward(pageid:int):Boolean///////////////////////////////
		{
			var id:int = pageid - BenefitHallMgr.BUTTON_XianshiFangsong1;
			for each(var item:LimitBigSendActItem in m_LimitBigSendActItemListOfDay[id].m_LimitBigSendActItemList)
			{
				var itemInfo:stLimitBigSendItem = m_LimitBigSendItemList[item.m_id];
				if (itemInfo && (itemInfo.m_progress - item.m_condition * itemInfo.m_rewardtimes) >= item.m_condition 
					&& (item.m_rewardtimes == 0 || item.m_rewardtimes != itemInfo.m_rewardtimes))//当 条目有信息 且 当前进度不小于进度阀值 且(总兑换次数为零 或 
																								//当前兑换次数不等于总兑换次数)时btn亮 显示有奖标志
				{
					return true;
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
		public function isact(pageid:uint):Boolean
		{
			if (m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond() < m_startTime)
			{
				return false;
			}
			var day:int=UtilTime.s_computeDayDifference_7(m_startTime,m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond())+1;
			var item:ItemOfDay = m_LimitBigSendActItemListOfDay[pageid];
			if (item.m_begin <= day && day <= item.m_end + 1)
			{
				return true;
			}
			return false;
		}
		public function process7ClockUserCmd():void
		{
			for (var i:int = 0; i < 4; i++ )
			{
				var pageid:int = BenefitHallMgr.BUTTON_XianshiFangsong1 + i;
				if (isact(i))
				{
					if (m_gkContext.m_UIs.benefitHall)
					{
						m_gkContext.m_UIs.benefitHall.addPage(pageid);
					}
				}
				else
				{
					if (m_gkContext.m_UIs.benefitHall)
					{
						m_gkContext.m_UIs.benefitHall.removePage(pageid);
						notify_noReward(pageid);
					}
				}
			}
		}
	}

}