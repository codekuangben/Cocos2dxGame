package modulecommon.scene.dtrebate 
{
	import com.util.UtilCommon;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.dtGetRechargeBackRewardCmd;
	import modulecommon.net.msg.activityCmd.dtNotifyRechargeBackDataCmd;
	import modulecommon.net.msg.activityCmd.dtUpdateRechargeYuanbaoCmd;
	import modulecommon.scene.benefithall.rebate.RechargeRebateItem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * 定时充值返利数据管理 DTRechargeRebate 
	 */
	public class DTRechargeRebateMgr 
	{
		/**
		 * gk公共数据
		 */
		private var m_gkcontext:GkContext;
		/**
		 * 累计充值元宝数
		 */
		private var m_cumulativeYB:uint	
		//private var m_activation:Boolean;	//充值返利开启状态 true为开启状态
		/**
		 * 条目数组 RechargeRebateItem
		 */
		private var m_rebateItemList:Array;
		/**
		 * 领取状态 按位
		 */
		private var m_state:uint;	
		/**
		 * xml加载标记
		 */
		private var m_idLoaded:Boolean;	
		/**
		 * 界面显示活动时间
		 */
		public var m_bTime:uint;
		/**
		 * 活动持续时间 配合m_bTime计算 m_eTime
		 */
		public var m_dTime:uint;	
		public function DTRechargeRebateMgr(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_idLoaded = false;
		}
		/**
		 * 定时充值返利载入xml（同充值返利xml）
		 */
		private function loadconfig():void
		{
			if (m_idLoaded)
			{
				return;
			}
			m_rebateItemList = new Array();
			var xml:XML = m_gkcontext.m_dataXml.getXML(DataXml.XML_DTRechargeRebate);
			var tabXml:XML;
			for each (tabXml in xml.elements("item"))
			{
				var item:RechargeRebateItem = new RechargeRebateItem();
				item.parse(tabXml);
				m_rebateItemList.push(item);
			}
			m_idLoaded = true;
		}
		/**
		 * 累计充值上线数据 初始化消息
		 */
		public function process_dtNotifyRechargeBackDataCmd(byte:ByteArray, param:uint):void
		{
			var rev:dtNotifyRechargeBackDataCmd = new dtNotifyRechargeBackDataCmd();
			rev.deserialize(byte);
			m_cumulativeYB = rev.m_yuanbao;
			m_state = rev.m_back;
			m_bTime = rev.m_bTime;
			m_dTime = rev.m_dTime;
		}
		/**
		 * 更新累计充值数据 冲元宝消息
		 */
		public function process_dtUpdateRechargeYuanbaoCmd(byte:ByteArray, param:uint):void
		{
			var rev:dtUpdateRechargeYuanbaoCmd = new dtUpdateRechargeYuanbaoCmd();
			rev.deserialize(byte);
			m_cumulativeYB = rev.m_yuanbao;
			var rechargeParam:Object = new Object();
			rechargeParam.type = 1;
			rechargeParam.state = updateBtnList();
			if (m_gkcontext.m_UIs.dtRechatge)//btn改变
			{
				m_gkcontext.m_UIs.dtRechatge.update(rechargeParam);
			}
			showBtnEffect();
			
		}
		/**
		 * 根据充值元宝计算按钮组开启状态（按位）
		 * @return 按钮开启状态 按位
		 */
		private function updateBtnList():uint
		{
			if (!m_rebateItemList)
			{
				loadconfig();
			}
			var btnState:uint = 0;
			for (var i:uint = 0; i < m_rebateItemList.length; i++ )
			{
				if (m_cumulativeYB >= m_rebateItemList[i].m_numYB && !UtilCommon.isSetUint(m_state, i))
				{
					btnState = UtilCommon.setStateUint(btnState, i);
				}
			}
			return btnState;
		}
		/**
		 * 界面按钮是否显示旋转特效的标志 true-显示特效
		 */
		public function get btnEffectFlag():Boolean
		{
			if (updateBtnList()!=0)
			{
				return true;
			}
			return false;
		}
		/**
		 * 控制界面按钮显示或隐藏特效
		 */
		private function showBtnEffect():void
		{
			if (m_gkcontext.m_UIs.screenBtn )
			{
				if (btnEffectFlag)
				{
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_DTRechargeRebate, true);
				}
				else
				{
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_DTRechargeRebate, false);
				}
			}
			
		}
		/**
		 * 领奖消息
		 */
		public function process_dtGetRechargeBackRewardCmd(byte:ByteArray, param:uint):void
		{
			var rev:dtGetRechargeBackRewardCmd = new dtGetRechargeBackRewardCmd();
			rev.deserialize(byte);
			m_state = UtilCommon.setStateUint(m_state, rev.m_index);
			var backParam:Object = new Object();
			backParam.type = 2;
			backParam.state = rev.m_index;
			if (m_gkcontext.m_UIs.dtRechatge)//btn改变
			{
				m_gkcontext.m_UIs.dtRechatge.update(backParam);
			}
			showBtnEffect();
			/* 更新 vip3 体验
			if (UtilCommon.isSetUint((backParam.state as uint), 1))
			{	
				var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
				if (vipty)
				{
					vipty.update(backParam);
				}
			}*/
		}
		/**
		 * 与下一个即将达到的元宝等级相差的元宝数量
		 */
		public function get catchYB():uint
		{
			var num:uint = uint.MAX_VALUE;
			if (!m_rebateItemList)
			{
				loadconfig();
			}
			for (var i:uint = 0; i < m_rebateItemList.length; i++)
			{
				if (m_cumulativeYB < m_rebateItemList[i].m_numYB && m_rebateItemList[i].m_numYB < num)
				{
					num = m_rebateItemList[i].m_numYB;
				}
			}
			return num - m_cumulativeYB;
		}
		/**
		 * 显示相差元宝数的条目号
		 */
		public function nextRebateid():uint
		{
			var num:uint = uint.MAX_VALUE;
			for (var i:uint = 0; i < m_rebateItemList.length; i++)
			{
				if (m_cumulativeYB < m_rebateItemList[i].m_numYB && m_rebateItemList[i].m_numYB < num)
				{
					num = i;
				}
			}
			return num;
		}
		/**
		 * 累积元宝
		 */
		public function get cumulativeYB():uint
		{
			return m_cumulativeYB;
		}
		/**
		 * 充值返利数组静态数据
		 */
		public function get rebateItemList():Array
		{
			return m_rebateItemList;
		}
		/**
		 * 已经领取
		 */
		public function isReceived(id:uint):Boolean
		{
			return UtilCommon.isSetUint(m_state, id);
		}
		
		// 获取 vip3 的奖励内容，yuanbao 数量
		/*public function getJLLstByYuanBao(yuanbao:uint):RechargeRebateItem
		{
			if (!m_rebateItemList)
			{
				loadconfig();
			}
			for (var i:uint = 0; i < m_rebateItemList.length; i++)
			{
				if (m_rebateItemList[i].m_numYB == yuanbao)
				{
					return m_rebateItemList[i];
				}
			}
			return null;
		}*/
	}

}