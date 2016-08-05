package modulecommon.scene.antiaddiction 
{
	import modulecommon.GkContext;
	//import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.time.Daojishi;
	//import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 * 防沉迷提示
	 */
	public class AntiAddictionMgr 
	{
		private var m_gkContext:GkContext;
		private var m_daojishi:Daojishi;
		
		public function AntiAddictionMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		//显示防沉迷提示
		public function showAntiAddictionPrompt():void
		{
			var hour:uint = m_gkContext.m_beingProp.m_timeOnLine;
			var desc:String;
			if (1 == hour)
			{
				desc = "您已累计在线1小时，请注意休息。";
			}
			else if (2 == hour)
			{
				desc = "您已累计在线2小时，请注意休息。";
			}
			else if (3 == hour)
			{
				if (null == m_daojishi)
				{
					m_daojishi = new Daojishi(m_gkContext.m_context);
				}
				m_daojishi.initLastTime = 10 * 1000;
				m_daojishi.funCallBack = updateDaoJiShi;
				m_daojishi.begin();
				desc = onConfirmDesc();
			}
			else
			{
				desc = "由于您是未成年人，您将被纳入防沉迷系统，3小时后将被系统强制下线。";
			}
			
			m_gkContext.m_confirmDlgMgr.showMode2(0, desc, onConfirmFun, "确定");
		}
		
		private function onConfirmFun():Boolean
		{
			return true;
		}
		
		private function onConfirmDesc():String
		{
			var ret:String;
			
			ret = "您已累计在线3小时，倒计时结束后将自动下线。  " + m_daojishi.timeSecond.toString() + "秒";
			
			return ret;
		}
		
		private function updateDesc():void
		{
			m_gkContext.m_confirmDlgMgr.updateDesc(onConfirmDesc());
		}
		
		private function updateDaoJiShi(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
			
			updateDesc();
		}
	}

}