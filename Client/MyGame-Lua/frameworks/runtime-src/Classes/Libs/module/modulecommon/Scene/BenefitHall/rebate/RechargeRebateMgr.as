package modulecommon.scene.benefithall.rebate 
{
	import com.util.DebugBox;
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.activityCmd.getRechargeBackRewardCmd;
	import modulecommon.net.msg.activityCmd.notifyRechargeBackDataCmd;
	import modulecommon.net.msg.activityCmd.updateRechargeYuanbaoCmd;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilCommon;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIVipTiYan;
	
	/**
	 * 原充值返利 现充值送将数据管理器
	 * @author 
	 */
	public class RechargeRebateMgr
	{
		/**
		 * 此活动自开服算持续天数
		 */
		public static const RECHARGEREBATE_activeTime:uint = 7;
		/**
		 * 公共字段
		 */
		private var m_gkcontext:GkContext;
		/**
		 * 累计充值
		 */
		private var m_cumulativeYB:uint
		/**
		 * 领取的奖励数组的数组 RechargeRebateItem
		 */
		private var m_rebateItemList:Array;
		/**
		 * 奖励按钮数组 读xml文件id为-1的列
		 */
		public var m_rewardList:Array;
		/**
		 * 领取状态 按位
		 */
		private var m_state:uint;
		/**
		 * 是否加载过
		 */
		private var m_idLoaded:Boolean;
		public function RechargeRebateMgr(gk:GkContext)
		{
			m_gkcontext = gk;
			m_idLoaded = false;
			
		}
		/**
		 * 载入DataXml.XML_RechargeRebate
		 */
		private function loadconfig():void
		{
			if (m_idLoaded)
			{
				return;
			}
			m_rebateItemList = new Array();
			var xml:XML = m_gkcontext.m_dataXml.getXML(DataXml.XML_RechargeRebate);
			var tabXml:XML;
			for each (tabXml in xml.elements("item"))
			{
				var item:RechargeRebateItem = new RechargeRebateItem();
				item.parse(tabXml);
				if (item.m_id == -1)
				{
					m_rewardList = item.m_rebateObjList;
				}
				else
				{
					m_rebateItemList.push(item);
				}
			}
			m_idLoaded = true;
		}
		/**
		 * 初始化消息 上线或者开启活动发送
		 */
		public function process_notifyRechargeBackDataCmd(byte:ByteArray, param:uint):void
		{
			var rev:notifyRechargeBackDataCmd = new notifyRechargeBackDataCmd();
			rev.deserialize(byte);
			m_cumulativeYB = rev.m_yuanbao;
			m_state = rev.m_back;
			showBtnEffect();//与定时充值返利不同的是这个页面充值后才显示 即有可能初始化就有特效
		}
		/**
		 * 冲元宝消息
		 */
		public function process_updateRechargeYuanbaoCmd(byte:ByteArray, param:uint):void//
		{
			var rev:updateRechargeYuanbaoCmd = new updateRechargeYuanbaoCmd();
			rev.deserialize(byte);
			m_cumulativeYB = rev.m_yuanbao;
			if (m_gkcontext.m_UIs.rechatge)//btn改变 进度条改变 特效改变
			{
				m_gkcontext.m_UIs.rechatge.update();
			}
			showBtnEffect();
		}
		/**
		 * 获得可领取状态btn
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
		 * 可领奖励数量
		 * @return
		 */
		public function actBtnNum():uint
		{
			if (!m_rebateItemList)
			{
				loadconfig();
			}
			var num:uint = 0;
			for (var i:uint = 0; i < m_rebateItemList.length; i++ )
			{
				if (m_cumulativeYB >= m_rebateItemList[i].m_numYB && !UtilCommon.isSetUint(m_state, i))
				{
					num++;
				}
			}
			return num;
		}
		/**
		 * 领奖消息
		 */
		public function process_getRechargeBackRewardCmd(byte:ByteArray, param:uint):void
		{
			var rev:getRechargeBackRewardCmd = new getRechargeBackRewardCmd();
			rev.deserialize(byte);
			m_state = UtilCommon.setStateUint(m_state, rev.m_index);
			var backParam:Object = new Object();
			backParam.type = 2;
			backParam.state = rev.m_index;
			if (m_gkcontext.m_UIs.rechatge)//btn改变
			{
				m_gkcontext.m_UIs.rechatge.update();
			}
			showBtnEffect();
			// 更新 vip3 体验
			//if (UtilCommon.isSetUint((backParam.state as uint), 1))
			//{	
				var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
				if (vipty)
				{
					vipty.update(backParam);
				}
			//}
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
			return num-m_cumulativeYB;
		}
		/**
		 * 返回显示相差元宝数的条目号
		 * @return
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
		 * 累积元宝数
		 */
		public function get cumulativeYB():uint
		{
			return m_cumulativeYB;
		}
		/**
		 * m_rebateItemList数组
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
			var num:uint = actBtnNum();
			if(m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateLblCnt(num, ScreenBtnMgr.Btn_RechargeRebate, ScreenBtnMgr.LBLCNTBGTYPE_Blue);
			}
			/*if (m_gkcontext.m_UIs.screenBtn)
			{
				if (btnEffectFlag)
				{
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_RechargeRebate, true,"ejhuodongteshu.swf");
				}
				else
				{
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_RechargeRebate, false);
				}
			}*/
			
		}
		
		/**
		 * 获取 vip3 的奖励内容，yuanbao 数量
		 * @param	yuanbao
		 * @return
		 */ 
		public function getJLLstByYuanBao(yuanbao:uint):RechargeRebateItem
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
		}
		/**
		 * 返回SJItemOfHlist子控件状态
		 * @param	index
		 * @return
		 */
		public function getSJItemState(index:int):int
		{
			//返回数值参见SJItemOfHlist.m_state（0-未达到 1-已达到未领取 2-已领取）
			if (isReceived(index))
			{
				return 2;
			}
			else if (cumulativeYB >= m_rebateItemList[index].m_numYB)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}

}