package modulecommon.scene.benefithall.welfarepackage 
{
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.buyWelfareDataCmd;
	import modulecommon.net.msg.activityCmd.getBackWelfareDataCmd;
	import modulecommon.net.msg.activityCmd.notifyWelfareDataCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	import time.UtilTime;
	/**
	 * ...
	 * @author 
	 */
	public class WelfarePackageMgr implements IBenefitSubSystem
	{
		public static const WELFARE_TYPE_ONE:uint = 0;//1k礼包
		public static const WELFARE_TYPE_FIV:uint = 1;//5k礼包
		
		public static const WELFARE_OP_BUY:uint = 0;//购买
		public static const WELFARE_OP_HARVEST:uint = 1;//领取
		public static const WELFARE_OP_NEXTDAY:uint = 2;//跨日
		
		private var m_gkContext:GkContext
		public var m_activation:Boolean;//福利礼包开启状态 true为开启状态;
		private var m_packageState:Dictionary;//礼包状态 key为type;//m_leftTime:uint; //服务器发来时间立即转化为剩余天数， 领取礼包或者跨日直接改变此值 分有购买日期与无购买日期改变
		public var m_actStartTime:Number;
		public var m_actEndTime:Number;
		//private var m_sNowTime:Number;//服务器发来当前时间
		
		public function WelfarePackageMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_activation = true;
			m_actStartTime = 0;
			m_actEndTime = 0;
			m_packageState = new Dictionary();
		}
		public function process_notifyWelfareDataCmd(byte:ByteArray, param:uint):void //上线初始化 或者 通知界面新增页
		{
			var rev:notifyWelfareDataCmd = new notifyWelfareDataCmd();
			rev.deserialize(byte);
			m_actStartTime = rev.m_beginTime;
			m_actEndTime = rev.m_endTime;
			var m_sNowTime:Number = rev.m_NowTime;
			m_packageState = rev.m_welFareList;
			var over:int = 0;
			for (var i:uint = 0; i < 2; i++ )
			{
				var State:Object = m_packageState[i];
				if (State.m_buyTime == 0)
				{
					State.m_leftTime = 30;
				}
				else
				{
					var passDay:uint = UtilTime.s_computeDayDifference_0(State.m_buyTime, m_sNowTime);
					var leftTime:int = 30 - passDay;
					if (State.m_buyback == 1)
					{
						leftTime--;
					}
					if (leftTime < 0)
					{
						leftTime = 0;
					}
					if (leftTime == 0)
					{
						++over;
					}
					State.m_leftTime = leftTime;
				}
			}
			if (over == 2)
			{
				m_activation = false;
				return;
			}
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.addPage(BenefitHallMgr.BUTTON_FuliLibao);
			}
			
		}
		public function process_buyWelfareDataCmd(byte:ByteArray, param:uint):void //购买礼包
		{
			var rev:buyWelfareDataCmd = new buyWelfareDataCmd();
			rev.deserialize(byte);
			if (rev.m_ret==1)
			{
				return;
			}
			var state:Object = m_packageState[rev.m_type];
			state.m_buyTime = 1;//购买时间置为非零
			state.m_buyback = 0;//1代表领取过 这里赋值为了服务器那边在notifyWelfareDataCmd时乱赋值
			var dataState:Object = new Object();
			dataState.m_type = rev.m_type;
			dataState.m_op = WELFARE_OP_BUY;
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.updateDataOnePage(BenefitHallMgr.BUTTON_FuliLibao,dataState);
			}
			if (m_gkContext.m_benefitHallMgr.hasRewardByID(BenefitHallMgr.BUTTON_FuliLibao))
			{
				return;
			}
			if (hasReward(BenefitHallMgr.BUTTON_FuliLibao))
			{
				notify_hasReward(BenefitHallMgr.BUTTON_FuliLibao);
			}
		}
		public function process_getBackWelfareDataCmd(byte:ByteArray, param:uint):void //领取礼包
		{
			var rev:getBackWelfareDataCmd = new getBackWelfareDataCmd();
			rev.deserialize(byte);
			if (rev.m_ret == 1)
			{
				return;
			}
			var state:Object = m_packageState[rev.m_type];
			state.m_leftTime--;
			state.m_buyback = 1;
			var dataState:Object = new Object();
			dataState.m_type = rev.m_type;
			dataState.m_op = WELFARE_OP_HARVEST;
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.updateDataOnePage(BenefitHallMgr.BUTTON_FuliLibao,dataState);
			}
			if (!hasReward(BenefitHallMgr.BUTTON_FuliLibao))
			{
				notify_noReward(BenefitHallMgr.BUTTON_FuliLibao);
			}
		}
		public function dayRefresh():void
		{
			if (!m_packageState)
			{
				return;
			}
			for (var i:uint = 0; i < 2; i++ )
			{
				var state:Object = m_packageState[i];
				if (state.m_buyTime != 0)
				{
					if (state.m_buyback == 1)
					{
						state.m_buyback = 0;
					}
					else
					{
						if (state.m_leftTime > 0)
						{
							state.m_leftTime--;
						}
					}
					var dataState:Object = new Object();
					dataState.m_type = i;
					dataState.m_op = WELFARE_OP_NEXTDAY;
					if (m_gkContext.m_UIs.benefitHall)
					{
						m_gkContext.m_UIs.benefitHall.updateDataOnePage(BenefitHallMgr.BUTTON_FuliLibao,dataState);
					}
				}
				
			}
			
			
		}
		public function packageState(id:uint):Object
		{
			return m_packageState[id];
		}
		
		public function hasReward(id:int):Boolean
		{
			if (!m_activation)
			{
				return false;
			}
			if (m_packageState)
			{
				for (var i:uint = 0; i < 2; i++ )
				{
					var State:Object = m_packageState[i];
					if (State && State.m_buyTime != 0 && State.m_leftTime > 0 && State.m_buyback != 1)//不为空 且 已购买 且 剩余天数大于0 且 未领取
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
	}

}