package modulecommon.scene.worldboss 
{
	import com.util.UtilXML;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.GkContext;
	import modulecommon.net.msg.worldbossCmd.stBossInfo;
	import modulecommon.net.msg.worldbossCmd.stBossPosInfo;
	import modulecommon.net.msg.worldbossCmd.stBossPositionInfoWBCmd;
	import modulecommon.net.msg.worldbossCmd.stEncourageLefttimesWBCmd;
	import modulecommon.net.msg.worldbossCmd.stInspireLefttimesWBCmd;
	import modulecommon.net.msg.worldbossCmd.stJoinWorldBossTimesWBCmd;
	import modulecommon.net.msg.worldbossCmd.stNotifyActStateWBCmd;
	import modulecommon.net.msg.worldbossCmd.stNotifyActWaitTimeWBCmd;
	import modulecommon.net.msg.worldbossCmd.stNotifyBossInfoWBCmd;
	import modulecommon.net.msg.worldbossCmd.stNotifyReliveTimeWBCmd;
	import modulecommon.net.msg.worldbossCmd.stReqEncourageWBCmd;
	import modulecommon.net.msg.worldbossCmd.stReqEnterWorldBossWBCmd;
	import modulecommon.net.msg.worldbossCmd.stReqInspireWBCmd;
	import modulecommon.net.msg.worldbossCmd.stReqLeaveWorldBossWBCmd;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIWorldBossSys;
	/**
	 * ...
	 * @author ...
	 * 世界boss
	 */
	public class WorldBossMgr 
	{
		public static const MAXCOUNTS_JOIN:int = 1;//每日参与最大次数
		
		public static const ACTSTATE_PRE:int = 1;	//等待
		public static const ACTSTATE_START:int = 2; //活动开始
		public static const ACTSTATE_TIMER:int = 3; //活动中
		public static const ACTSTATE_END:int = 4;	//活动结束
		
		public static const RANKLISTNUM:uint = 10;		//伤害榜数量
		public static const COMFORTDAMPER:Number = 0.03;//伤害百分比(安慰奖) =3%
		
		public static const TIME_WAIT:int = 1;		//等待倒计时
		public static const TIME_REBORN:int = 2;	//复活倒计时
		
		private var m_gkContext:GkContext;
		private var m_vecRankReward:Vector.<RewardInfo>;	//排名奖励
		private var m_vecComfortReward:Vector.<RewardInfo>;	//安慰奖励
		private var m_bHasConfigData:Boolean;				//奖励配置信息是否已读取
		private var m_daojishi:Daojishi;
		private var m_bNoQueryInspire:Boolean = false;		//点击“鼓舞”按钮，是否出现提示
		private var m_joinTimes:int;						//今日参与次数
		
		public var m_curState:int;			//1等待 2活动开始 3活动中 4活动结束
		public var m_bInWBoss:Boolean;		//是否已进入世界boss地图
		public var m_exciteLefttimes:uint;		//激励剩余次数
		public var m_invigorateLeftTimes:uint;	//鼓舞剩余次数
		public var m_leftTime:uint;			//倒计时间(/s)
		public var m_timeType:int;			//倒计时类型 1等待 2复活
		public var m_vecBossInfo:Vector.<stBossInfo>;		//boss信息
		public var m_vecBossPosInfo:Vector.<stBossPosInfo>;	//boss位置坐标
		public var m_bNoQueryReborn:Boolean = false;	//点击“立即战斗”、“立即复活”
		
		public function WorldBossMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bInWBoss = false;
			m_bHasConfigData = false;
			m_vecBossInfo = new Vector.<stBossInfo>();
		}
		
		//通知活动状态
		public function processNotifyActStateWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stNotifyActStateWBCmd = new stNotifyActStateWBCmd();
			ret.deserialize(msg);
			
			m_curState = ret.m_state;
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				var bAni:Boolean = false;
				if (ACTSTATE_PRE == m_curState || ACTSTATE_START == m_curState || ACTSTATE_TIMER == m_curState)
				{
					bAni = true;
				}
				
				m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_WorldBoss, bAni);
			}
			
			if (ACTSTATE_PRE == m_curState)
			{
				var hintParam:Object = new Object();
				hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_ActFeature;
				hintParam["featuretype"] = HintMgr.ACTFUNC_WORLDBOSS;
				m_gkContext.m_hintMgr.hint(hintParam);
			}
		}
		
		//通知boss信息
		public function processNotifyBossInfoWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stNotifyBossInfoWBCmd = new stNotifyBossInfoWBCmd();
			ret.deserialize(msg);
			
			var boss:stBossInfo;
			var bossInfo:stBossInfo;
			var i:int;
			var j:int;
			for (i = 0; i < ret.m_bossList.length; i++)
			{
				boss = ret.m_bossList[i];
				bossInfo = getBossInfoByID(boss.bossid);
				
				if (bossInfo)
				{
					bossInfo.killNum = boss.killNum;
					bossInfo.killreward.num = boss.killreward.num;
					bossInfo.killreward.objID = boss.killreward.objID;
				}
				else
				{
					m_vecBossInfo.push(boss);
				}
				
				var npc:NpcVisit = m_gkContext.m_npcManager.getBeingByNpcID(boss.bossid) as NpcVisit;
				if (npc)
				{
					npc.updateNameDesc();
				}
			}
			
			m_vecBossInfo.sort(compare);
			
			var form:IUIWorldBossSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys) as IUIWorldBossSys;
			if (form)
			{
				form.updateBossHpInfoData();
			}
		}
		
		private function compare(a:stBossInfo, b:stBossInfo):int
		{
			if (a.bossid < b.bossid)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		//通知活动等待时间
		public function processNotifyActWaittimeWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stNotifyActWaitTimeWBCmd = new stNotifyActWaitTimeWBCmd();
			ret.deserialize(msg);
			
			m_leftTime = ret.m_waittime;
			
			if (m_leftTime)
			{
				showDaojishi(m_leftTime, TIME_WAIT);
			}
		}
		
		//通知排行榜信息
		public function processNotifyRanklistInfoWbCmd(msg:ByteArray, param:int):void
		{
			var form:IUIWorldBossSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys) as IUIWorldBossSys;
			if (form)
			{
				form.processWorldBossCmd(msg, param);
			}
		}
		
		//通知复活等待时间
		public function processNotifyReliveTimeWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stNotifyReliveTimeWBCmd = new stNotifyReliveTimeWBCmd();
			ret.deserialize(msg);
			
			m_leftTime = ret.m_sec;
			if (m_leftTime)
			{
				showDaojishi(m_leftTime, TIME_REBORN);
			}
			else
			{
				setStopDaojishi();
			}
		}
		
		//鼓舞剩余次数
		public function processInspireLefttimesWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stInspireLefttimesWBCmd = new stInspireLefttimesWBCmd();
			ret.deserialize(msg);
			
			m_invigorateLeftTimes = ret.m_times;
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateLeftTimes(AttrBufferMgr.Buffer_Guwu, m_invigorateLeftTimes);
			}
		}
		
		//剩余激励次数
		public function processEncourageLefttimesWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stEncourageLefttimesWBCmd = new stEncourageLefttimesWBCmd();
			ret.deserialize(msg);
			
			m_exciteLefttimes = ret.m_times;
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.updateLeftTimes(AttrBufferMgr.Buffer_Jili, m_exciteLefttimes);
			}
		}
		
		//世界BOSS今日参与次数
		public function processJoinWorldbossTimesWbCmd(msg:ByteArray, param:int):void
		{
			var ret:stJoinWorldBossTimesWBCmd = new stJoinWorldBossTimesWBCmd();
			ret.deserialize(msg);
			
			m_joinTimes = ret.joinTimes;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_WorldBoss, -1, leftJoinTimes);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftJoinTimes, ScreenBtnMgr.Btn_WorldBoss);
			}
		}
		
		//战斗信息
		public function processFightResultInfoWbCmd(msg:ByteArray, param:int):void
		{
			var form:IUIWorldBossSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys) as IUIWorldBossSys;
			if (form)
			{
				form.processWorldBossCmd(msg, param);
			}
		}
		
		//请求进入
		public function reqEnterWorldBoss():void
		{
			//世界boss只能从主城地图进入(常山村、长安城)
			if (MapInfo.MTMain == m_gkContext.m_mapInfo.mapType())
			{
				var cmd:stReqEnterWorldBossWBCmd = new stReqEnterWorldBossWBCmd();
				m_gkContext.sendMsg(cmd);
			}
			else
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
			}
		}
		
		//请求离开
		public function reqLeaveWorldBoss():void
		{
			var cmd:stReqLeaveWorldBossWBCmd = new stReqLeaveWorldBossWBCmd();
			m_gkContext.sendMsg(cmd);
		}
		
		//请求鼓舞、激励
		public function reqEncourageAddInspire(bufferid:uint):void
		{
			if (AttrBufferMgr.Buffer_Guwu == bufferid)
			{
				if (!m_bNoQueryInspire && m_invigorateLeftTimes)
				{
					var radio:Object = new Object();
					radio[ConfirmDialogMgr.RADIOBUTTON_select] = false;
					radio[ConfirmDialogMgr.RADIOBUTTON_desc] = "不再询问";
					var desc:String = "花费 20元宝 提升5%全军能力？提升攻击力、防御力、兵力、速度。";
					m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIWorldBossSys, desc, ConfirmBringBtnFn, null, "确认", "取消", radio);
				}
				else
				{
					ConfirmBringBtnFn();
				}
			}
			else if (AttrBufferMgr.Buffer_Jili == bufferid)
			{
				var encourageCmd:stReqEncourageWBCmd = new stReqEncourageWBCmd();
				m_gkContext.sendMsg(encourageCmd);
			}
		}
		
		private function ConfirmBringBtnFn():Boolean
		{
			if (m_gkContext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_bNoQueryInspire = true;
			}
			
			var inspireCmd:stReqInspireWBCmd = new stReqInspireWBCmd();
			m_gkContext.sendMsg(inspireCmd);
			
			return true;
		}
		
		//boss血量信息
		public function processNotifyBossHpInfoWbCmd(msg:ByteArray, param:int):void
		{
			var form:IUIWorldBossSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys) as IUIWorldBossSys;
			if (form)
			{
				form.processWorldBossCmd(msg, param);
			}
			else
			{
				m_gkContext.m_contentBuffer.addContent("stNotifyBossHpInfoWBCmd", msg);
			}
		}
		
		//boss位置信息
		public function processBossPositionInfoWbCmd(msg:ByteArray, param:int):void
		{
			var rev:stBossPositionInfoWBCmd = new stBossPositionInfoWBCmd();
			rev.deserialize(msg);
			
			m_vecBossPosInfo = rev.m_vecBossPos;
		}
		
		//进入世界boss地图
		public function enterWBoss():void
		{
			m_bInWBoss = true;
			loadConfig();
			
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIWorldBossSys);
			
			m_gkContext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkContext.m_taskMgr.hideUITaskTrace();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.addBufferIcon(AttrBufferMgr.TYPE_WORLDBOSS, AttrBufferMgr.Buffer_Guwu);
				m_gkContext.m_UIs.hero.addBufferIcon(AttrBufferMgr.TYPE_WORLDBOSS, AttrBufferMgr.Buffer_Jili);
			}
		}
		
		//离开世界boss地图
		public function leaveWBoss():void
		{
			m_bInWBoss = false;
			
			m_vecBossInfo.length = 0;
			
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys);
			if (form)
			{
				form.exit();
			}
			
			m_gkContext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkContext.m_taskMgr.showUITaskTrace();
			m_gkContext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.removeBufferIcon(AttrBufferMgr.Buffer_Guwu);
			}
			m_gkContext.m_attrBufferMgr.removeOneBufferByID(AttrBufferMgr.Buffer_Jili);
		}
		
		//读取配置信息:奖励
		private function loadConfig():void
		{
			if (m_bHasConfigData)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_commonXML.getItem(8);
			var xmlList:XMLList = xml.child("rankreward");
			var itemXML:XML;
			var reward:RewardInfo;
			
			m_vecRankReward = new Vector.<RewardInfo>();
			for each(itemXML in xmlList)
			{
				reward = new RewardInfo();
				reward.id = UtilXML.attributeIntValue(itemXML, "id");
				reward.boxid = UtilXML.attributeIntValue(itemXML, "boxid");
				
				m_vecRankReward.push(reward);
			}
			
			xmlList = null;
			xmlList = xml.child("comfortreward");
			m_vecComfortReward = new Vector.<RewardInfo>();
			for each(itemXML in xmlList)
			{
				reward = new RewardInfo();
				reward.boxid = UtilXML.attributeIntValue(itemXML, "boxid");
				
				m_vecComfortReward.push(reward);
			}
			
			m_bHasConfigData = true;
			m_gkContext.m_commonXML.deleteItem(8);
		}
		
		//排名奖励
		public function getRankRewardByIndex(index:uint = 0):uint
		{
			if (m_vecRankReward && index < m_vecRankReward.length)
			{
				return m_vecRankReward[index].boxid;
			}
			
			return 0;
		}
		
		//安慰奖励
		public function getComfortRewardByIndex(index:uint = 0):uint
		{
			if (m_vecComfortReward && m_vecComfortReward.length)
			{
				return m_vecComfortReward[index].boxid;
			}
			
			return 0;
		}
		
		//获得Boss信息
		public function getBossInfoByID(bossid:uint):stBossInfo
		{
			var i:int;
			
			for (i = 0; i < m_vecBossInfo.length; i++)
			{
				if (m_vecBossInfo[i].bossid == bossid)
				{
					return m_vecBossInfo[i];
				}
			}
			
			return null;
		}
		
		//显示倒计时提示
		private function showDaojishi(time:uint, type:int):void
		{
			m_timeType = type;
			
			if (null == m_daojishi)
			{
				m_daojishi = new Daojishi(m_gkContext.m_context);
			}
			
			beginDaojishi(time * 1000);
		}
		
		//leftTime 单位为毫秒
		private function beginDaojishi(leftTime:int):void
		{ 
			m_daojishi.funCallBack = updateDaojishi;
			m_daojishi.initLastTime = leftTime;
			m_daojishi.begin();
			updateDaojishi(m_daojishi);
		}
		
		private function updateDaojishi(t:Daojishi):void
		{
			m_leftTime = t.timeSecond;
			
			var minute:uint = m_leftTime / 60;
			var seconds:uint = m_leftTime % 60;
			var timeStr:String = UtilTools.intToString(minute) + " : " + UtilTools.intToString(seconds);
			
			if (m_daojishi.isStop())
			{
				setStopDaojishi();
			}
			else
			{
				var form:IUIWorldBossSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIWorldBossSys) as IUIWorldBossSys;
				if (form)
				{
					if (true == m_gkContext.m_UIMgr.isFormVisible(UIFormID.UIWorldBossReborn))
					{
						form.updateLeftTime(timeStr);
					}
					else
					{
						if (false == form.openUI(UIFormID.UIWorldBossReborn))
						{
							m_gkContext.m_UIMgr.showForm(UIFormID.UIWorldBossReborn);
						}
					}
				}
			}
		}
		
		//结束倒计时
		private function setStopDaojishi():void
		{
			m_daojishi.end();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UIWorldBossReborn);
		}
		
		//今日剩余参与次数
		public function get leftJoinTimes():int
		{
			var ret:int;
			
			if (m_joinTimes > MAXCOUNTS_JOIN)
			{
				ret = 0;
			}
			else
			{
				ret = MAXCOUNTS_JOIN - m_joinTimes;
			}
			
			return ret;
		}
		
		//早上7点刷新
		public function process7ClockUserCmd():void
		{
			m_joinTimes = 0;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_WorldBoss, -1, leftJoinTimes);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(leftJoinTimes, ScreenBtnMgr.Btn_WorldBoss);
			}
		}
		
		//获得boss位置坐标
		public function getBossPosByID(id:uint):Point
		{
			var ret:Point;
			var bossPos:stBossPosInfo;
			
			for each(bossPos in m_vecBossPosInfo)
			{
				if (bossPos.bossId == id)
				{
					ret = new Point(bossPos.x, bossPos.y);
					break;
				}
			}
			
			return ret;
		}
	}

}