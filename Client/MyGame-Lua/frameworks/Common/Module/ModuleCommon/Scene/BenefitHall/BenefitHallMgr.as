package modulecommon.scene.benefithall 
{
	import com.util.UtilCommon;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;	
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author 
	 * 福利大厅数据管理
	 */
	public class BenefitHallMgr
	{
		public static const BUTTON_HuoyueFuli:int = 0;	//活跃福利
		public static const BUTTON_MeiriQiandao:int = 1;	//每日签到
		public static const BUTTON_QiriDenglu:int = 2;	//七日登陆奖
		public static const BUTTON_FuliLibao:int = 3;	//福利礼包
		public static const BUTTON_Quanminchongbang:int = 4;	//全民冲榜
		public static const BUTTON_XianshiFangsong1:int = 5;	//限时放送
		public static const BUTTON_XianshiFangsong2:int = 6;	//限时放送
		public static const BUTTON_XianshiFangsong3:int = 7;	//限时放送
		public static const BUTTON_XianshiFangsong4:int = 8;	//限时放送
		public static const BUTTON_JLZhaoHui:int = 9;	//奖励找回
		public static const BUTTON_Jihuoma:int = 10;	//激活码兑换
		public static const BUTTON_Num:int = 11;	//数量	
		
		private var m_gkContext:GkContext;	
		private var m_rewardFlag:uint=0;	//按位存储
		
		private var m_dicSubSys:Dictionary;
		public function BenefitHallMgr(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		/*
		 *在SceneUserProcess::processSynOnlineFinDataUsercmd()中调用此函数。
		 */
		public function initFlag():void
		{
			//这个操作是为了防止processSynOnlineFinDataUsercmd被调用2次
			if (m_dicSubSys)
			{
				return;
			}
			
			m_dicSubSys = new Dictionary();
			m_dicSubSys[BUTTON_HuoyueFuli] = m_gkContext.m_dailyActMgr;
			m_dicSubSys[BUTTON_MeiriQiandao] = m_gkContext.m_dailyActMgr;
			m_dicSubSys[BUTTON_QiriDenglu] = m_gkContext.m_qiridengluMgr;
			m_dicSubSys[BUTTON_FuliLibao] = m_gkContext.m_welfarePackageMgr;
			m_dicSubSys[BUTTON_Quanminchongbang] = m_gkContext.m_peopleRankMgr;
			m_dicSubSys[BUTTON_XianshiFangsong1] = m_gkContext.m_LimitBagSendMgr;
			m_dicSubSys[BUTTON_XianshiFangsong2] = m_gkContext.m_LimitBagSendMgr;
			m_dicSubSys[BUTTON_XianshiFangsong3] = m_gkContext.m_LimitBagSendMgr;
			m_dicSubSys[BUTTON_XianshiFangsong4] = m_gkContext.m_LimitBagSendMgr;
			m_dicSubSys[BUTTON_JLZhaoHui] = m_gkContext.m_jlZhaoHuiMgr;
			
			var strID:String;
			var id:int;
			var iSubSys:IBenefitSubSystem;
			for (strID in m_dicSubSys)
			{
				iSubSys = m_dicSubSys[strID];
				id = parseInt(strID);
				if (iSubSys.hasReward(id))
				{
					m_rewardFlag = UtilCommon.setStateUint(m_rewardFlag, id);
				}				
			}
		}
		
		public function onNotify_hasReward(id:int):void
		{
			if (UtilCommon.isSetUint(m_rewardFlag, id))
			{
				return;
			}
			
			var oldHasReward:Boolean = hasRewardInBenefitHall();
			m_rewardFlag = UtilCommon.setStateUint(m_rewardFlag, id);
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.showRewardFlag(id, true);
			}
			
			if (!oldHasReward)
			{
				if (m_gkContext.m_UIs.screenBtn)
				{
					m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_BenefitHall, true);
				}
			}
		}
		public function onNotify_noReward(id:int):void
		{
			if (false==UtilCommon.isSetUint(m_rewardFlag, id))
			{
				return;
			}
			var oldHasReward:Boolean = hasRewardInBenefitHall();
			m_rewardFlag = UtilCommon.clearStateUint(m_rewardFlag, id);
			if (m_gkContext.m_UIs.benefitHall)
			{
				m_gkContext.m_UIs.benefitHall.showRewardFlag(id, false);
			}
			if (oldHasReward && m_rewardFlag == 0)
			{
				if (m_gkContext.m_UIs.screenBtn)
				{
					m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_BenefitHall, false);
				}
			}
		}
		//true - 表示id所对应的活动当前有奖励可领取
		public function hasRewardByID(id:int):Boolean
		{
			return UtilCommon.isSetUint(m_rewardFlag, id);
		}
		
		public function hasRewardInBenefitHall():Boolean
		{
			return m_rewardFlag > 0;
		}
		
		public function get isInit():Boolean
		{
			return m_dicSubSys != null;
		}
	}

}