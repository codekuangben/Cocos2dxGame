package game.logic
{
	import modulecommon.GkContext;
	import modulecommon.logicinterface.ICorpsCitySys;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.time.Daojishi;
	import time.TimeL;

	//import com.util.UtilTools;

	/**
	 * @brief 军团城市系统
	 * */
	public class CorpsCitySys implements ICorpsCitySys
	{
		protected var m_gkcontext:GkContext;
		protected var m_inScene:Boolean;	// 在军团争夺战场景，地图  8  是一个临时场景，这个不断，进入能看到人的场景才是在场景中，如果在场景中需要切换头顶显示的名字
		
		//protected var m_aStartHour:int;		// 活动开始时间
		//protected var m_aEndHour:int;		// 活动结束时间
		//protected var m_aStartMin:int;		// 活动开始时间
		//protected var m_aEndMin:int;		// 活动结束时间
		//protected var m_sStartHour:int;		// 闪烁开始时间
		//protected var m_sEndHour:int;		// 闪烁结束时间
		//protected var m_sStartMin:int;		// 活动开始时间
		//protected var m_sEndMin:int;		// 活动结束时间
		
		//protected var m_aStartSec:Number;	// 活动开始的秒的时候，做盘算使用
		//protected var m_aEndSec:Number;	// 活动开始的秒的时候，做盘算使用
		//protected var m_sStartSec:Number;	// 活动开始的秒的时候，做盘算使用
		//protected var m_sEndSec:Number;	// 活动开始的秒的时候，做盘算使用
		
		//protected var m_btnShine:Boolean;		// 按钮是否闪烁
		protected var m_inActive:Boolean;			// 是否在活动时间内
		
		//protected var m_daojishi:Daojishi;

		public function CorpsCitySys(value:GkContext)
		{
			m_gkcontext = value;
			
			//m_aStartHour = 0;
			//m_aStartMin = 0;
			//m_aEndHour = 23;
			//m_aEndMin = 59;
			
			//m_sStartHour = 8;
			//m_sStartMin = 0;
			//m_sEndHour = 8;
			//m_sEndMin = 20;
			
			//m_sStartHour = 14;
			//m_sStartMin = 0;
			//m_sEndHour = 15;
			//m_sEndMin = 0;
			
			//m_aStartSec = m_aStartHour * 3600 + m_aStartMin * 60;
			//m_aEndSec = m_aEndHour * 3600 + m_aEndMin * 60;
			//m_sStartSec = m_sStartHour * 3600 + m_sStartMin * 60;
			//m_sEndSec = m_sEndHour * 3600 + m_sEndMin * 60;
			
			//m_btnShine = false;
			m_inActive = false;
			
			//beginDaojishi();
		}

		public function get inActive():Boolean
		{
			return m_inActive;
		}

		public function set inActive(value:Boolean):void
		{
			m_inActive = value;

			if(m_inActive)
			{
				if(m_gkcontext.m_UIs.screenBtn)	// 更改按钮图标
				{
					m_gkcontext.m_UIs.screenBtn.changeBtnIcon(ScreenBtnMgr.Btn_CorpsCitySys, "corpscitysys1f")
				}
			}
			else if(!m_inActive)
			{
				if(m_gkcontext.m_UIs.screenBtn)
				{
					m_gkcontext.m_UIs.screenBtn.changeBtnIcon(ScreenBtnMgr.Btn_CorpsCitySys, "corpscitysys");
				}
			}
		}

		public function get inScene():Boolean
		{
			return m_inScene;
		}

		public function set inScene(value:Boolean):void
		{
			m_inScene = value;
		}
		
		// 判断是不是在活动期间
		//public function inATime():Boolean
		//{
		//	var cur:Number = m_gkcontext.m_timeMgr.date.hours * 3600 + m_gkcontext.m_timeMgr.date.minutes * 60;
		//	if(m_aStartSec <= cur && cur <= m_aEndSec)
		//	{
		//		return true;
		//	}
		//	return false;
		//}
		
		// 判断是不是在发光期间
		//public function inSTime():Boolean
		//{
		//	var timeL:TimeL = m_gkcontext.m_timeMgr.getServerTimeL();
		//	var cur:Number = timeL.m_hour * 3600 + timeL.m_minute * 60;
		//	if(m_sStartSec <= cur && cur <= m_sEndSec)
		//	{
		//		return true;
		//	}
		//	return false;
		//}
		
		// 启动到计时, 1 秒倒计时，改变状态
		//public function beginDaojishi():void
		//{
		//	if (!m_daojishi)
		//	{
		//		m_daojishi = new Daojishi(m_gkcontext.m_context);
		//	}

		//	m_daojishi.funCallBack = updateDaojishi;
			
		//	m_daojishi.initLastTime = Number.MAX_VALUE;
		//	m_daojishi.begin();
		//}
		
		//protected function updateDaojishi(d:Daojishi):void
		//{
//			if(inATime())	// 如果在活动时间内
//			{
//				if(m_btnState == 0)
//				{
//					if(m_gkcontext.m_UIs.screenBtn && m_gkcontext.m_UIs.screenBtn.changeBtnIcon(ScreenBtnMgr.Btn_CorpsCitySys, "corpscitysys1"))	// 更改按钮图标
//					{
//						m_btnState = 1;	// 设置进入将活动状态
//					}
//				}
//			}
//			else	// 不在活动时间内
//			{
//				if(m_btnState == 1)
//				{
//					if(m_gkcontext.m_UIs.screenBtn)
//					{
//						m_gkcontext.m_UIs.screenBtn.changeBtnIcon(ScreenBtnMgr.Btn_CorpsCitySys, "corpscitysys");
//					}
//					m_btnState = 0;
//				}
//			}
			
			//if(inSTime())	// 如果在按钮发光时间内
			//{
			//	if(!m_btnShine)
			//	{
			//		if(m_gkcontext.m_UIs.screenBtn && m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsCitySys, true))
			//		{
			//			m_btnShine = true;
			//		}
			//	}
			//}
			//else	// 不在活动时间内
			//{
			//	if(m_btnShine)
			//	{
			//		if(m_gkcontext.m_UIs.screenBtn)
			//		{
			//			m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsCitySys, false);
			//		}
			//		m_btnShine = false;
			//	}
			//}
		//}
	}
}