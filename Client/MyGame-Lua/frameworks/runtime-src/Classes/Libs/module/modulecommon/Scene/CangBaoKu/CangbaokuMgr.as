package modulecommon.scene.cangbaoku 
{
	/**
	 * ...
	 * @author 
	 */
	//import com.gskinner.motion.easing.Back;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import flash.utils.ByteArray;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.net.msg.copyUserCmd.*;
	import modulecommon.time.Daojishi;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICangbaoku;
	import modulecommon.uiinterface.IUIScreenBtn;
	
	public class CangbaokuMgr 
	{
		public static const MAX_TANBAO_TIMES:int = 19;	//最大探宝次数
		public var m_gkContext:GkContext;
		private var m_iRemainedTimes:int;	//剩余探宝次数
		private var m_uColdTime:uint;	//冷却时间:(单位毫秒)
		private var m_daojishi:Daojishi;
		private var m_iLayer:int;
		private var m_ibInCangbaoku:Boolean;
		private var m_baoxiangList:Vector.<int>;
		public var m_uiCangbaoku:IUICangbaoku;
		
		public var m_refreshCnt:uint;		// 下一次刷新是第几次刷新, 从 1 开始,不是从 0 开始
		public var m_refreshReedMoney:uint;// 下一次说新需要的钱的数量
		
		public function CangbaokuMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		//登陆后，服务器主动发到客户端
		public function processRetCangBaoKuDataUserCmd(msg:ByteArray, param:int):void
		{
			var rev:stRetCangBaoKuDataUserCmd = new stRetCangBaoKuDataUserCmd();
			rev.deserialize(msg);			
			m_baoxiangList = rev.m_baoxiangList;
			m_iLayer = rev.m_iLayer;
			m_iRemainedTimes = rev.m_iRemainedTimes;
			
			m_refreshCnt = rev.refreshtimes;
			m_refreshReedMoney = rev.needmoney;
			
			// 更新 UI			
			if(m_uiCangbaoku != null)
			{
				m_uiCangbaoku.updateUIAttr();
				m_uiCangbaoku.updateUIList();
			}
			
			if (rev.m_time)
			{
				m_uColdTime = rev.m_time * 1000;
				createColdTimeDaojishi();
			}
			
			// 更新为开启的宝箱个数
			updateScreenBtnLblCnt();
		}
		
		//更新剩余探宝次数
		public function processUpdateRemainingCount(msg:ByteArray, param:int):void
		{
			var rev:stUpdateRemainingCount = new stUpdateRemainingCount();
			rev.deserialize(msg);
			m_iRemainedTimes = MAX_TANBAO_TIMES - rev.m_iRemainedTimes;
			
			// 更新 UI			
			if(m_uiCangbaoku != null)
			{
				m_uiCangbaoku.updateUIAttr();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Cangbaoku, -1, remainedTimes);
			}
			
			// 更新为开启的宝箱个数
			updateScreenBtnLblCnt();
		}
		
		//更新当前层数
		public function processUpdateCurLayer(msg:ByteArray, param:int):void
		{
			var rev:stUpdateCurLayer = new stUpdateCurLayer();
			rev.deserialize(msg);
			m_iLayer = rev.m_ilayer;
			
			// 更新 UI			
			if(m_uiCangbaoku != null)
			{
				m_uiCangbaoku.updateUIAttr();
			}
		}
		
		//更新宝箱列表;0: 增加一个箱子，  1:删除一个箱子    
		public function processUpdateBoxList(msg:ByteArray, param:int):void
		{
			var rev:stUpdateBoxList = new stUpdateBoxList();
			rev.deserialize(msg);
			
			if (rev.m_itype == 0)
			{
				m_baoxiangList.push(rev.m_ibox);
			}
			else
			{
				if (rev.m_ibox < m_baoxiangList.length)
				{
					m_baoxiangList.splice(rev.m_ibox, 1);
				}
			}
			
			// 更新 UI			
			if(m_uiCangbaoku != null)
			{
				if (rev.m_itype == 1)	// 如果删除一个宝箱
				{
					// 客户端显示的时候是最后一个宝箱在第一个，第一个宝箱在最后一个显示
					m_uiCangbaoku.updateUIList(rev.m_itype + 1, m_baoxiangList.length - rev.m_ibox);	// 注意这个地方不是 m_baoxiangList.length - 1 ，而是 m_baoxiangList.length ，因为这个箱子在列白哦中已经删除了，相当于已经减 1 了
				}
				else
				{
					m_uiCangbaoku.updateUIList(rev.m_itype + 1, rev.m_ibox);
				}
			}
			
			// 更新为开启的宝箱个数
			updateScreenBtnLblCnt();
		}	
		
		//进入藏宝窟
		public function processRetCreateCopyUserCmd(msg:ByteArray, param:int):void
		{
			// 更新 UI
			if(m_uiCangbaoku != null)
			{
				//cangbaoku.updateFaceLook();
				m_uiCangbaoku.exit();
			}
			// 这一行要放在上面的代码后面,因为重写的 exit 里面会判断 inCangbaoku 这个属性 
			m_gkContext.m_cangbaokuMgr.inCangbaoku = true;
			// 显示界面
			//m_gkContext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			this.m_gkContext.m_UIMgr.loadForm(UIFormID.UICangbaoku);
			m_gkContext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			// 隐藏藏宝库按钮显示
			//var uiscreen:IUIScreenBtn = m_gkContext.m_UIMgr.getForm(UIFormID.UIScreenBtn) as IUIScreenBtn;
			//if(uiscreen)
			//{
			//	uiscreen.toggleBtnVisible(0, false)
			//}
		}
		
		// 退出副本
		public function processsyncLeaveCopyUserCmd(msg:ByteArray, param:int):void
		{
			// 更新 UI
			m_gkContext.m_cangbaokuMgr.inCangbaoku = false;
			//m_gkContext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UIScreenBtn);
			
			if(m_uiCangbaoku != null)
			{
				//cangbaoku.updateFaceLook();
				m_uiCangbaoku.exit();
			}
			m_gkContext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkContext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			// 隐藏藏宝库按钮显示
			//var uiscreen:IUIScreenBtn = m_gkContext.m_UIMgr.getForm(UIFormID.UIScreenBtn) as IUIScreenBtn;
			//if(uiscreen)
			//{
			//	uiscreen.toggleBtnVisible(0, true)
			//}
		}
		
		//冷却时间更新
		public function processssCangBaoKuPkCoolingTimeUserCmd(time:uint):void
		{
			if (time == 0)
			{
				if (m_daojishi)
				{
					m_daojishi.end();
				}
				
				if (m_uColdTime != 0)
				{
					m_uColdTime = 0;
				}
				
				uiUpdateColdTime();
			}
			else
			{
				m_uColdTime = time * 1000;
				createColdTimeDaojishi();
			}
		}
		
		private function createColdTimeDaojishi():void
		{
			if (m_daojishi == null)
			{
				m_daojishi = new Daojishi(m_gkContext.m_context);
			}
			m_daojishi.initLastTime = m_uColdTime;
			m_daojishi.funCallBack = coldTimeUpdate;
			m_daojishi.begin();
		}
		
		private function coldTimeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_uColdTime = 0;
				m_daojishi.end();
			}
			
			uiUpdateColdTime();
		}
		
		private function uiUpdateColdTime():void
		{
			if(m_uiCangbaoku != null)
			{
				m_uiCangbaoku.updateColdTime();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Cangbaoku, coldTime, -1);
			}
		}
		
		public function get coldTime():uint
		{
			if (m_uColdTime == 0)
			{
				return 0;
			}
			else
			{
				return m_daojishi.timeSecond;
			}
		}
		
		//剩余探宝次数(玩家等级影响探宝次数)
		public function get remainedTimes():int
		{
			var ret:int = curTanbaoMaxTimes;
			var tanbaotimes:int = MAX_TANBAO_TIMES - m_iRemainedTimes;
			
			if (ret >= tanbaotimes)
			{
				ret -= tanbaotimes; 
			}
			else
			{
				ret = 0;
			}
			
			return ret;
		}
		
		public function get baoxiangList():Vector.<int>
		{
			return m_baoxiangList;
		}
		
		public function get baoxiangCount():uint
		{
			if (m_baoxiangList)
			{
				return m_baoxiangList.length;
			}
			
			return 0;
		}
		
		public function get inCangbaoku():Boolean
		{
			return m_ibInCangbaoku;
		}
		
		public function set inCangbaoku(value:Boolean):void
		{
			m_ibInCangbaoku = value;
		}
		
		public function get curLayer():int
		{
			return m_iLayer;
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			m_iRemainedTimes = MAX_TANBAO_TIMES;
			
			// 清除数据
			if(m_baoxiangList != null)
			{
				m_baoxiangList.length = 0;
			}
			
			if(m_uiCangbaoku != null)
			{
				m_uiCangbaoku.updateUIList();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Cangbaoku, -1, curTanbaoMaxTimes);
			}
			
			// 更新为开启的宝箱个数
			updateScreenBtnLblCnt();
		}
		
		public function updateTanbaoTimes():void
		{
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Cangbaoku, -1, remainedTimes);
			}
			
			// 更新为开启的宝箱个数
			updateScreenBtnLblCnt();
		}
		
		//更新活动按钮上数字显示
		private function updateScreenBtnLblCnt():void
		{
			var type:int = ScreenBtnMgr.LBLCNTBGTYPE_Red;
			
			if (m_baoxiangList && m_baoxiangList.length)
			{
				type = ScreenBtnMgr.LBLCNTBGTYPE_Blue;
			}
			
			if(m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftBoxCnt, ScreenBtnMgr.Btn_CANGBAOKU, type);
			}
		}
		
		// 点击刷新守卫返回的消息
		public function processRefreshCBKData(msg:ByteArray, param:int):void
		{
			var rev:stRetRefreshCBKDataUserCmd = new stRetRefreshCBKDataUserCmd();
			rev.deserialize(msg);
			
			m_refreshCnt = rev.refreshtimes;
			m_refreshReedMoney = rev.needmoney;
		}
		
		//未领取宝箱数为0时，返回今日挑战剩余次数
		public function get leftBoxCnt():uint
		{
			if (m_baoxiangList && m_baoxiangList.length)
			{
				return m_baoxiangList.length;
			}
			
			return remainedTimes;
		}
		
		//当前等级每日挑战最大次数
		public function get curTanbaoMaxTimes():uint
		{
			var ret:uint = 0;
			var level:uint;
			
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			
			if (level >= 40)
			{
				ret = 19;
			}
			else if (level >= 35)
			{
				ret = 18;
			}
			else if (level >= 25)
			{
				ret = 12;
			}
			else
			{
				ret = 6;
			}
			
			return ret;
		}
		
		//请求进入藏宝窟
		public function reqEnterCangbaoku():void
		{
			var cmd:stReqBoxTipContextUserCmd = new stReqBoxTipContextUserCmd();
			m_gkContext.sendMsg(cmd);
			
			var send:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
			send.copyid = 10000;
			m_gkContext.sendMsg(send);
		}
	}
}