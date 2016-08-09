package  modulecommon.scene.herorally 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sgQunYingCmd.UserZhanJi;
	import modulecommon.time.TimeItem;
	import time.TimeL;
	import time.TimeMgr;
	import time.UtilTime;
	/**
	 * ...
	 * @author 
	 */
	public class FieldData 
	{
		private static const delayTime:uint = 10 * 60;
		public var m_list:Dictionary//[index,UserZhanJi]
		private var m_startTime:uint;
		private var m_endTime:uint;
		public var m_tittleSting:String;
		private var m_gkcontext:GkContext
		private var m_fieldNo:uint;
		private var m_FieldTimeDic:Dictionary;
		public function FieldData(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_FieldTimeDic = m_gkcontext.m_heroRallyMgr.timeParam;
		}
		public function setdata(data:UserZhanJi):FieldData
		{
			if (!m_list)
			{
				init(data);
			}
			else
			{
				insert(data);
			}
			return this;
		}
		public function isThisField(data:UserZhanJi):Boolean
		{
			if (m_startTime <= data.m_time && data.m_time < m_endTime)
			{
				return true;
			}
			return false;
		}
		private function init(data:UserZhanJi):void
		{
			m_list = new Dictionary();
			var theWholeDayTime:uint = UtilTime.s_getDay_0(data.m_time);
			var zhanjiTimeToZero:uint = data.m_time-theWholeDayTime;
			var week:Array = ["日", "一", "二", "三", "四", "五", "六"];
			var curday:TimeL = m_gkcontext.m_context.m_timeMgr.calendarToTimeL(data.m_time);
			var str:String = "  周" + week[TimeMgr.s_weekByDate(curday.m_year, curday.m_month, curday.m_date)];
			var num:Array = [ "  上午场", "  下午场", "  晚场" ];
			
			for (var j:uint = 0; j < 3; j++ )
			{
				var item:FieldTimeParam = m_FieldTimeDic[j];
				var atThisField:Boolean = false;
				var bureauTimeList:Vector.<TimeItem> = new Vector.<TimeItem>();
				for (var i:uint = 0; i < 3; i++ )
				{
					var bureauTime:TimeItem = new TimeItem();
					bureauTime.parse_hourAndMinute(item.m_fightTime[i]);
					bureauTimeList.push(bureauTime);
				}
				var name:String;
				for (i = 0; i < 3; i++ )
				{
					if (bureauTimeList[i].elpasedTimeToZero <= zhanjiTimeToZero && zhanjiTimeToZero < bureauTimeList[i].elpasedTimeToZero + delayTime)
					{
						m_list[i] = data;
						name = data.m_name;
						atThisField = true;
						break;
					}
				}
				if (atThisField)
				{
					m_startTime = theWholeDayTime + bureauTimeList[0].elpasedTimeToZero;
					m_endTime = theWholeDayTime + bureauTimeList[2].elpasedTimeToZero + delayTime;
					m_tittleSting = str + num[j];
					m_fieldNo = j;
					var listitem:UserZhanJi = new UserZhanJi();
					listitem.m_name = name;
					listitem.m_result = 2;
					for (i = 0; i < 3; i++ )
					{
						if (!m_list[i])
						{
							m_list[i] = listitem;
						}
					}
					break;
				}
			}
		}
		private function insert(data:UserZhanJi):void
		{
			var full:Boolean = true;
			for (var i:uint = 0; i < 3;i++ )
			{
				if (!m_list[i] || (m_list[i] as UserZhanJi).m_result == 2)
				{
					full = false;
				}
			}
			if (full)
			{
				m_gkcontext.addLog("英雄会"+m_tittleSting+" 数据已满，插入战绩id="+data.m_zhanjiNo+" time="+data.m_time+"失败");
				return;
			}
			var item:FieldTimeParam = m_FieldTimeDic[m_fieldNo];
			var bureauTimeList:Vector.<TimeItem> = new Vector.<TimeItem>();
			for (i = 0; i < 3; i++ )
			{
				var bureauTime:TimeItem = new TimeItem();
				bureauTime.parse_hourAndMinute(item.m_fightTime[i]);
				bureauTimeList.push(bureauTime);
			}
			var theWholeDayTime:uint = UtilTime.s_getDay_0(data.m_time);
			var zhanjiTimeToZero:uint = data.m_time-theWholeDayTime;
			for (i = 0; i < 3; i++ )
			{
				if (bureauTimeList[i].elpasedTimeToZero <= zhanjiTimeToZero && zhanjiTimeToZero < bureauTimeList[i].elpasedTimeToZero + delayTime)
				{
					if (m_list[i] && (m_list[i] as UserZhanJi).m_result != 2)
					{
						m_gkcontext.addLog("英雄会" + m_tittleSting + " 插入战绩时间重复，初始战绩id=" + (m_list[i] as UserZhanJi).m_zhanjiNo + " time=" + (m_list[i] as UserZhanJi).m_time
											+ "，插入战绩id=" + data.m_zhanjiNo + " time=" + data.m_time);
						return;
					}
					else
					{
						m_list[i] = data;
					}
					break;
				}
			}
		}
		public function showEffect():Boolean
		{
			for each(var item:UserZhanJi in m_list)
			{
				if ((item.m_result == 1 || item.m_result == 3) && item.m_rewardflag == 0)
				{
					return true;
				}
			}
			return false;
		}
		public static function EffectiveData(gk:GkContext,data:UserZhanJi):Boolean
		{
			var fieldDic:Dictionary = gk.m_heroRallyMgr.timeParam;
			var theWholeDayTime:uint = UtilTime.s_getDay_0(data.m_time);
			var zhanjiTimeToZero:uint = data.m_time-theWholeDayTime;
			for (var j:uint = 0; j < 3; j++ )
			{
				var item:FieldTimeParam = fieldDic[j];
				var bureauTime:TimeItem = new TimeItem();
				bureauTime.parse_hourAndMinute(item.m_fightTime[0]);
				var start:uint = bureauTime.elpasedTimeToZero;
				bureauTime = new TimeItem();
				bureauTime.parse_hourAndMinute(item.m_fightTime[2]);
				var end:uint = bureauTime.elpasedTimeToZero + delayTime;
				if (start <= zhanjiTimeToZero && zhanjiTimeToZero < end)
				{
					return true;
				}
			}
			gk.addLog("英雄会 时间无效战绩 id=" + data.m_zhanjiNo + " time=" + data.m_time);
			return false;
		}
		public function setBoxState(id:uint):uint
		{
			for (var i:uint = 0; i < 3; i++ )
			{
				if ((m_list[i] as UserZhanJi).m_zhanjiNo == id)
				{
					(m_list[i] as UserZhanJi).m_rewardflag = 1;
					return i;
				}
			}
			return 3;
		}
	}

}