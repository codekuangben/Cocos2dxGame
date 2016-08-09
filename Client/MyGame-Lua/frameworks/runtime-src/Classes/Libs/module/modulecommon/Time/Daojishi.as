package modulecommon.time 
{
	import com.pblabs.engine.core.ITimeUpdateObject;
	import common.Context;
	
	/**
	 * ...
	 * @author ...
	 * 倒计时
	 */
	public class Daojishi implements ITimeUpdateObject 
	{
		public static const TIMEMODE_1Second:int = 0;
		public static const TIMEMODE_1Minute:int = 1;
		
		private var m_context:Context;
		private var m_timeMode:int = TIMEMODE_1Second;
		private var m_initTime:Number;	//倒计时的开始时间(毫秒)，elapsed time since flash starts
		private var m_initLastTime:Number;	//初始持续时间(毫秒)
				
		private var m_funCallBack:Function;
		private var m_addMark:Boolean;
		public function Daojishi(con:Context) 
		{
			m_context = con;
			m_addMark = false;
		}
		
		public function set initLastTime(v:Number):void
		{
			m_initLastTime = v;
		}
		
		public function set initLastTime_Second(v:Number):void
		{
			m_initLastTime = v*1000;
		}
		public function set timeMode(mode:int):void
		{
			m_timeMode = mode;
		}
		//返回剩余时间(单位:秒)
		public function get timeSecond():int
		{
			var lastTime:Number = m_context.m_processManager.platformTime - m_initTime;
			if (lastTime > m_initLastTime)
			{
				return 0;
			}
			else
			{
				return (m_initLastTime - lastTime)/1000;
			}
		}
		//返回剩余时间(单位:毫秒)
		public function get timeMillionSecond():int
		{
			var lastTime:Number = m_context.m_processManager.platformTime - m_initTime;
			if (lastTime > m_initLastTime)
			{
				return 0;
			}
			else
			{
				return m_initLastTime - lastTime;
			}
		}
		public function isStop():Boolean
		{
			var ret:Boolean = false;
			var lastTime:Number = m_context.m_processManager.platformTime - m_initTime;
			if (lastTime > m_initLastTime)
			{
				ret = true;
			}
			return ret;
		}
		public function set funCallBack(fun:Function):void
		{
			m_funCallBack = fun;
		}
		
		//initTime等于零表示从当前时刻开始计时
		public function begin(initTime:Number=0):void
		{
			if (initTime == 0)
			{
				m_initTime = m_context.m_processManager.platformTime;
			}
			else
			{
				m_initTime = initTime;
			}
			addToProcessManager();
		}
		
		public function end():void
		{
			removeFromProcessManager();
		}
		
		//暂停。就是将本对象从m_processManager中移除
		public function pause():void
		{
			removeFromProcessManager();
		}
		
		//与pause相反的操作，将本对象放入m_processManager中，进行更新。因为continue是as3的关键字，所有后面加_s
		public function continue_s():void
		{
			addToProcessManager();
		}
		private function addToProcessManager():void
		{
			if (m_addMark == false)
			{
				if (m_timeMode == TIMEMODE_1Second)
				{
					m_context.m_processManager.add1SecondUpateObject(this);
				}
				else if (m_timeMode == TIMEMODE_1Minute)
				{
					m_context.m_processManager.add1MinuteUpateObject(this);
				}				
				m_addMark = true;
			}
		}
		private function removeFromProcessManager():void
		{
			if (m_addMark == true)
			{
				m_addMark = false;
				if (m_timeMode == TIMEMODE_1Second)
				{
					m_context.m_processManager.remove1SecondUpateObject(this);
				}
				else if (m_timeMode == TIMEMODE_1Minute)
				{
					m_context.m_processManager.remove1MinuteUpateObject(this);
				}
				
			}
		}
		public function dispose():void
		{
			end();
			m_funCallBack = null;
		}
		public function onTimeUpdate():void
		{
			if (m_funCallBack != null)
			{
				m_funCallBack(this);
			}
		}
		
	}

}