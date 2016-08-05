package modulecommon.scene.elitebarrier
{
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.GkContext;
	import modulecommon.scene.MapInfo;
	import modulecommon.net.msg.eliteBarrierCmd.stNotifyLeftEliteBossNumCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stNotifyEliteBossInfoCmd;
	import modulecommon.net.msg.eliteBarrierCmd.stReqIntoEliteBossCopy;
	import modulecommon.net.msg.worldbossCmd.stBossInfo;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * 新精英boss
	 * @author ...
	 */
	public class EliteBarrierMgr
	{
		/*public var m_gkContext:GkContext;精英boss原代码
		
		public var m_data:Array;
		public var m_curBarrier:uint;
		public var m_hasData:Boolean;
		public var m_lefttimes:uint;	//战役挑战剩余次数
		public var m_hasPkCounts:uint;	//今日已挑战次数
		public var m_timesOfBuy:int;	//当天，已经购买的挑战次数
		public var m_bubbleList:Vector.<String>;
		
		public function EliteBarrierMgr(gk:GkContext):void
		{
			m_gkContext = gk;
			m_curBarrier = 0;
			m_hasData = false;
		}
		
		public function setData(data:stRetBarrierDataCmd):void
		{
			m_data = data.m_list;
			m_hasData = true;
		}
		
		//通过当前选择的关卡Id，获得当前关卡name
		public function getCurBarrierName(curId:uint):String
		{
			for each (var item:stBarrier in m_data)
			{
				if (item.m_id == curId)
				{
					return item.m_name;
				}
			}
			
			return null;
		}
		
		public function get eliteBarrierData():Array
		{
			return m_data;
		}
		
		public function showTipsAfterFightFail():void
		{
			m_gkContext.m_confirmDlgMgr.showMode1(0, "很遗憾你战败了，想翻身你可以。。。", gotoCathSlaveFn, openZhanliUpgradeFormFn, "抓更强的战俘", "提升自己", null, true);
		}
		
		private function gotoCathSlaveFn():Boolean
		{
			m_gkContext.m_confirmDlgMgr.showMode1(0, "现在去抓战俘", GotoCangBaoKuFn, GotoGuanZhiJingJiFn, "藏宝库抓战俘", "竞技场抓战俘", null, true);
			return true;
		}
		
		private function openZhanliUpgradeFormFn():Boolean
		{
			if (m_gkContext.m_zhanliupgradeMgr.hasRequest() == false)
			{
				m_gkContext.m_zhanliupgradeMgr.loadConfig();
			}
			
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIZhanliUpgrade) == false)
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIZhanliUpgrade);
			}
			return true;
		}
		
		private function GotoCangBaoKuFn():Boolean
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CANBAOKU))
			{
				m_gkContext.m_cangbaokuMgr.reqEnterCangbaoku();
			}
			else
			{
				m_gkContext.m_systemPrompt.prompt("藏宝库 功能还未开启");
			}
			return true;
		}
		
		private function GotoGuanZhiJingJiFn():Boolean
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JINGJICHANG))
			{
				m_gkContext.m_arenaMgr.enterArena();
			}
			else
			{
				m_gkContext.m_systemPrompt.prompt("竞技场 功能还未开启");
			}
			return true;
		}
		
		public function setLeftTimes(count:uint):void
		{
			m_lefttimes = count;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_EliteBarrier, -1, m_lefttimes);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(m_lefttimes, ScreenBtnMgr.Btn_EliteBarrier);
			}
			
			var uiBarrierZhanfa:IUIBarrierZhenfa = m_gkContext.m_UIMgr.getForm(UIFormID.UIBarrierZhenfa) as IUIBarrierZhenfa;
			if (uiBarrierZhanfa)
			{
				uiBarrierZhanfa.updateLeftCountsLabel();
			}
		}
		
		public function process_stRefreshBuyChallengeTimesCmd(msg:ByteArray):void
		{
			var rev:stRefreshBuyChallengeTimesCmd = new stRefreshBuyChallengeTimesCmd();
			rev.deserialize(msg);
			m_timesOfBuy = rev.m_buytimes;
		}
		
		public function getBubble():String
		{
			if (m_bubbleList == null)
			{
				m_bubbleList = new Vector.<String>();
				var itemXML:XML;
				var xml:XML = m_gkContext.m_commonXML.getItem(4);
				if (xml)
				{
					var xmlList:XMLList = xml.child("item");
					var str:String;
					for each (itemXML in xmlList)
					{
						
						str = itemXML.attribute("desc");
						m_bubbleList.push(str);
					}
					m_gkContext.m_commonXML.deleteItem(4);
				}
			}
			
			var i:int = Math.floor(Math.random() * m_bubbleList.length);
			if (i < m_bubbleList.length)
			{
				return m_bubbleList[i];
			}
			return null;
		}
		
		//请求打开精英boss关卡选择界面
		public function openFormOfEliteBarrier():void
		{
			var sendBarrier:stReqBarrierDataCmd = new stReqBarrierDataCmd();
			if (false == m_gkContext.m_elitebarrierMgr.m_hasData)
			{
				sendBarrier.hasData = 0;
			}
			else
			{
				sendBarrier.hasData = 1;
			}
			m_gkContext.sendMsg(sendBarrier);
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			m_timesOfBuy = 0;
		}
		
		//每日挑战总次数
		public function get pkMaxCounts():uint
		{
			return m_gkContext.m_vipPrivilegeMgr.getPrivilegeValue(VipPrivilegeMgr.Vip_Barrier);
		}*/

		public static const JBOSS_MAXCOUNTS:uint = 12;
		/**
		 * 公共字段
		 */
		private var m_gkcontext:GkContext
		/**
		 * 上线获得剩余boss数量 用于screenbtn显示label
		 */
		public var m_lfBossNum:int;
		/**
		 * 进入精英boss标志 true-处于jyboss中
		 */
		public var m_bInJBoss:Boolean;
		/**
		 * 借用wboss的boss数据结构
		 */
		private var m_bossInfo:stBossInfo;
		public function EliteBarrierMgr(gk:GkContext):void
		{
			m_gkcontext = gk;
		}
		/**
		 * 进入精英boss地图
		 */
		public function enterJBoss():void
		{
			m_bInJBoss = true;
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkcontext.m_localMgr.set(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			m_gkcontext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkcontext.m_taskMgr.hideUITaskTrace();
			m_gkcontext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			if (m_gkcontext.m_UIs.hero && m_gkcontext.m_beingProp.vipLevel == 0)
			{
				m_gkcontext.m_UIs.hero.addBufferIcon(AttrBufferMgr.TYPE_WORLDBOSS, AttrBufferMgr.BufferID_Woxinchangdan);
			}
		}
		
		/**
		 * 离开精英boss地图
		 */
		public function leaveJBoss():void
		{
			m_bInJBoss = false;
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskTrace);
			m_gkcontext.m_localMgr.clear(LocalDataMgr.LOCAL_HIDE_UITaskPrompt);
			m_gkcontext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkcontext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			m_gkcontext.m_taskMgr.showUITaskTrace();
			if (m_gkcontext.m_UIs.hero && m_gkcontext.m_beingProp.vipLevel == 0)
			{
				m_gkcontext.m_UIs.hero.removeBufferIcon(AttrBufferMgr.BufferID_Woxinchangdan);
			}
			
		}
		
		/**
		 * 请求进入精英boss
		 */
		public function reqEnterJBoss():void
		{
			//世界boss只能从主城地图进入(常山村、长安城)
			if (MapInfo.MTMain == m_gkcontext.m_mapInfo.mapType())
			{
				var cmd:stReqIntoEliteBossCopy = new stReqIntoEliteBossCopy();
				m_gkcontext.sendMsg(cmd);
			}
			else
			{
				m_gkcontext.m_mapInfo.promptInFubenDesc();
			}
		}
		
		/**
		 * 精英boss获取screenbtn上的剩余数量
		 * @param
		 */
		public function process_stEliteBossOnlineInfoCmd(msg:ByteArray):void
		{
			var rev:stNotifyLeftEliteBossNumCmd = new stNotifyLeftEliteBossNumCmd();
			rev.deserialize(msg);
			m_lfBossNum = rev.m_leftbossnum;
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_EliteBarrier, -1, m_lfBossNum);
			}
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateLblCnt(m_lfBossNum, ScreenBtnMgr.Btn_EliteBarrier);
			}
		}
		/**
		 * 通知boss信息
		 * @param
		 */
		public function process_stNotifyEliteBossInfoCmd(msg:ByteArray):void
		{
			var rev:stNotifyEliteBossInfoCmd = new stNotifyEliteBossInfoCmd();
			rev.deserialize(msg);
			
			if (!m_bossInfo)
			{
				m_bossInfo = new stBossInfo();
			}
			m_bossInfo.killNum = rev.m_pkbatch - 1;
			m_bossInfo.killreward.num = rev.m_num;
			m_bossInfo.killreward.objID = rev.m_objid;
			m_bossInfo.bossid = rev.m_bossid;
			
			var npc:NpcVisit = m_gkcontext.m_npcManager.getBeingByTmpID(m_bossInfo.bossid);
			if (npc)
			{
				npc.updateNameDesc();
			}
		}
		/**
		 * 获得JBoss信息 
		 * @return
		 */
		public function getBossInfoByID():stBossInfo
		{
			return m_bossInfo;
		}
		/**
		 * 跨7点设置任务与screenbtn剩余次数
		 * @param	count
		 */
		public function setLeftTimes(count:uint):void
		{
			m_lfBossNum = count;
			
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_EliteBarrier, -1, m_lfBossNum);
			}
			
			if (m_gkcontext.m_UIs.screenBtn)
			{
				m_gkcontext.m_UIs.screenBtn.updateLblCnt(m_lfBossNum, ScreenBtnMgr.Btn_EliteBarrier);
			}
			
		}
	}

}