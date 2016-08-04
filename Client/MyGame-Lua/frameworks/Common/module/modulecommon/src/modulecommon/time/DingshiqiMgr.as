package modulecommon.time 
{
	import modulecommon.GkContext;
	import com.pblabs.engine.core.ITimeUpdateObject;
	import time.UtilTime;
	/**
	 * ...
	 * @author 
	 * 定时器
	 * 根据服务器时间，进行定时，每1分钟检测一次
	 */
	public class DingshiqiMgr  implements ITimeUpdateObject 
	{
		private var m_gkContext:GkContext;
		private var m_list:Vector.<DingshiqiItem>;
		private var m_addMark:Boolean;
		public function DingshiqiMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_list = new Vector.<DingshiqiItem>();			
		}
		
		/*
		 *添加计时器，ti表示当天的时间
		 * 返回值，true - 添加成功
		 * 			false - 表示ti表示的时间已过		 
		 */
		public function addByTimeItem(ti:TimeItem, funOnTimeUp:Function):Boolean
		{
			var nowTime:Number = m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond();
			var t:Number = UtilTime.s_getDay_0(nowTime) + ti.elpasedTimeToZero;
			if (nowTime > t)
			{
				return false;
			}
			var ds:DingshiqiItem = new DingshiqiItem();
			ds.m_data = ti;
			ds.m_funOnTimeUp = funOnTimeUp;
			ds.m_platform = m_gkContext.m_context.m_timeMgr.calendarTimeToPlatformTime(t);
			m_list.push(ds);
			addToProcessManager();
			return true;
		}
		
		public function removeTimeItem(ti:TimeItem):void
		{
			var ds:DingshiqiItem;
			for each(ds in m_list)
			{
				if (ds.m_data == ti)
				{
					var i:int = m_list.indexOf(ds);
					if (i != -1)
					{
						m_list.splice(i, 1);
					}	
					return;
				}
			}
		}
		
				
		public function onTimeUpdate():void
		{
			var ds:DingshiqiItem;
			var pft:Number = m_gkContext.m_context.m_processManager.platformTime;
			var delList:Vector.<DingshiqiItem>;
			for each(ds in m_list)
			{
				if (pft >= ds.m_platform )
				{
					if (delList == null)
					{
						delList = new Vector.<DingshiqiItem>();
					}
					
					delList.push(ds);
					if (ds.m_funOnTimeUp)
					{
						ds.m_funOnTimeUp(ds.m_data);
					}
				}
			}
			
			if (delList)
			{
				for each(ds in delList)
				{
					var i:int = m_list.indexOf(ds);
					if (i != -1)
					{
						m_list.splice(i, 1);
					}					
				}
				
				if (m_list.length == 0)
				{
					m_gkContext.m_context.m_processManager.remove1MinuteUpateObject(this);
				}
			}
		}
		
		private function addToProcessManager():void
		{
			if (m_addMark == false)
			{
				m_gkContext.m_context.m_processManager.add1MinuteUpateObject(this);			
				m_addMark = true;
			}
		}
		private function removeFromProcessManager():void
		{
			if (m_addMark == true)
			{
				m_addMark = false;
				m_gkContext.m_context.m_processManager.remove1MinuteUpateObject(this);
				
			}
		}
	}

}