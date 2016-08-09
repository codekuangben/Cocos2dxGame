package modulecommon.scene.tongquetai 
{
	//import adobe.utils.CustomActions;
	import common.Context;
	import modulecommon.net.msg.wunvCmd.DancingWuNvMsg;
	import modulecommon.time.Daojishi;
	/**
	 * ...
	 * @author 
	 */
	public class DancingWuNv 
	{
		public static const STATE_Dancing:int = 1;	//正在跳舞
		public static const STATE_Over:int = 0;	//跳舞结束，等待收获
		
		private var m_mgr:TongQueTaiMgr;
		public var m_dancingMsg:DancingWuNvMsg;		
		public var m_dancerBase:DancerBase;		
		private var m_daojishi:Daojishi;
		private var m_state:int;
		private var m_showtime:int;
		public function DancingWuNv(con:Context,mgr:TongQueTaiMgr) 
		{
			m_mgr = mgr;
			m_daojishi = new Daojishi(con);
			//m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_daojishi.funCallBack = timeUpdate;
		}
		public function init(dancingMsg:DancingWuNvMsg):void
		{
			m_dancingMsg = dancingMsg;
			m_dancerBase = m_mgr.getDancerByID(m_dancingMsg.id);
			if (m_dancingMsg.time == 0)
			{
				m_state = STATE_Over;
				m_mgr.addTimeUp();
			}
			else
			{
				m_state = STATE_Dancing;
				m_daojishi.initLastTime_Second = m_dancingMsg.time;
				m_showtime = -1;
				m_daojishi.begin();
			}	
			var list:Array = m_dancingMsg.stolenList;
			for (var i:uint = 0; i < list.length; i++ )//自己舞女被盗数额添加
			{
				if (i == 0)
				{
					list[i].m_value = m_dancerBase.m_outputvalue / 10;
				}
				else
				{
					list[i].m_value = m_dancerBase.m_outputvalue / 20;
				}
			}
		}
		
		public function init2(id:uint, tempid:uint, pos:uint):void
		{
			m_dancerBase = m_mgr.getDancerByID(id);
			m_dancingMsg = new DancingWuNvMsg();
			m_dancingMsg.id = id;
			m_dancingMsg.pos = pos;
			m_dancingMsg.tempid = tempid;
			m_dancingMsg.time = m_dancerBase.m_worktime;
			m_dancingMsg.stolenList = new Array();
			init(m_dancingMsg);
		}
		
		private function timeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_state = STATE_Over;
				m_daojishi.end();
				m_mgr.addTimeUp();
				if (m_mgr.m_uiWuhui)
				{
					m_mgr.m_uiWuhui.becomeOver(this);
				}
			}
			if (m_mgr.m_uiWuhui && m_mgr.m_uiWuhui.isVisible())
			{
				if (m_showtime > 0)
				{
					m_showtime--;
				}
				else if (m_showtime < 0)
				{
					var timeAndStr:Object = m_mgr.chatByRandom();
					m_showtime = timeAndStr.time;
				}
				else
				{
					timeAndStr = m_mgr.chatByRandom();
					var Str:String = timeAndStr.str;
					m_mgr.m_uiWuhui.showChat(m_dancingMsg.pos, Str);
					m_showtime = timeAndStr.time;
				}
			}
			if (m_mgr.m_uiWuhui)
			{
				m_mgr.m_uiWuhui.updataTime(m_dancingMsg.pos);
			}
			
		}
		public function dispose():void
		{
			m_daojishi.dispose();
		}
		public function get isDancing():Boolean
		{
			return STATE_Dancing == m_state;
		}		
		public function get remainingTime():int
		{
			return m_daojishi.timeSecond;
		}
		public function get stolenList():Array//这里如若舞女收益数额不是100的整数倍，则不保证数值准确度
		{
			return m_dancingMsg.stolenList;
		}
	}

}