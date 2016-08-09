package modulecommon.scene.zhanchang 
{
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.stResRobCmd.synIntoRobResDataUserCmd;
	import modulecommon.net.msg.stResRobCmd.synResRobTimesUserCmd;
	import modulecommon.net.msg.stResRobCmd.updateResRobWinTimeDownCountUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUISanguoZhangchang;
	import modulecommon.time.Daojishi;
	import modulecommon.uiinterface.IUISanguoZhangchangEnter;
	/**
	 * ...
	 * @author ...
	 * enum { SHIBING=0, PIANJIANG, DAJIANG,   YUANSHUAI, QINWANG, TITLE_NONE};

	 */
	public class SanguoZhanChangMgr  
	{
		public static const MAXCOUNTS_GOIN:int = 2;	//三国战场，每日最大参与次数
		
		public static const ZHENYING_Wei:int = 0;	//魏
		public static const ZHENYING_Shu:int = 1;	//蜀
		public static const ZHENYING_Wu:int = 2;	//吴
		
		public static const TITLE_ShiBing:int = 0;	//士兵
		public static const TITLE_PianJiang:int = 1;//偏将
		public static const TITLE_daJiang:int = 2;	//大将
		public static const TITLE_YuShuai:int = 3;	//元帅
		public static const TITLE_QinWang:int = 4;	//亲王
		
		private var m_gkContext:GkContext;
		private var m_dicReward:Dictionary;
		private var m_timesOfEnter:int;	//进入战场的次数
		private var m_zhenying:int;
		private var m_remainedTime:uint;//单位：毫秒
		private var m_platformTimeToRemainedTime:uint;
		private var m_bInZhanchang:Boolean;
		
		public var m_woxinchangdanLevel:int;	//卧薪尝胆状态等级
		
		private var m_nextFightTime:Daojishi;//私有倒计时
		private var m_bInJinGongJianGe:Boolean;//攻击间隔状态
		private var m_inTimeRemain:int;//攻击间隔剩余时间(ms)
		
		public function SanguoZhanChangMgr(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		public function getRulerDesc():String
		{
			var xml:XML = m_gkContext.m_commonXML.getItem(5);
			if (xml)
			{
				var xmlList:XMLList = xml.child("rule_desc");
				if (xmlList&&xmlList.length()==1)
				{
					return xmlList[0].toString();
				}
			}
			return null;
		}
		
		public function process_synResRobTimesUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:synResRobTimesUserCmd = new synResRobTimesUserCmd();
			rev.deserialize(msg);
			m_timesOfEnter = rev.times;
			onTimesOfEnterUpdate();
		}
		
		public function process_synIntoRobResDataUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:synIntoRobResDataUserCmd = new synIntoRobResDataUserCmd();
			rev.deserialize(msg);
			m_zhenying = rev.zhenying;
			m_gkContext.playerMain.m_zhenying = m_zhenying;
			m_remainedTime = rev.time * 1000;
			m_platformTimeToRemainedTime = m_gkContext.m_context.m_processManager.platformTime;
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UISanguoZhangchang);
		}
		
		public function process_updateResRobWinTimeDownCountUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateResRobWinTimeDownCountUserCmd = new updateResRobWinTimeDownCountUserCmd;
			rev.deserialize(msg);
			m_inTimeRemain = rev.intervalTime * 1000;
			m_bInJinGongJianGe = true;
			startFightTime();
		}
		
		protected function onTimesOfEnterUpdate():void
		{
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_SanguoZhanchang, -1, timesOfReward);
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(timesOfReward, ScreenBtnMgr.Btn_Sanguozhanchang);
			}
			
			var uiEnter:IUISanguoZhangchangEnter = m_gkContext.m_UIMgr.getForm(UIFormID.UISanguoZhangchangEnter) as IUISanguoZhangchangEnter;
			if (uiEnter)
			{
				uiEnter.updateTimes();
			}
			
		}
		
		//返回值--单位：毫秒
		public function get remainedTime():uint
		{
			var tElapsed:uint = m_gkContext.m_context.m_processManager.platformTime - m_platformTimeToRemainedTime;
			if (m_remainedTime >= tElapsed)
			{
				return m_remainedTime - tElapsed;
			}
			else
			{
				return 0;
			}
			
		}
		
		//返回名次奖励描述：rank-名次
		public function getBoxDesc(rank:int):String
		{
			if (m_dicReward == null)
			{
				loadBoxDesc();
			}
			return m_dicReward[rank];
		}
		
		private function loadBoxDesc():void
		{
			m_dicReward = new Dictionary();
			var xml:XML = m_gkContext.m_commonXML.getItem(6);
			var xmlList:XMLList;
			var xmlItem:XML;
			xmlList = xml.child("item");
			var rank:int;
			for each(xmlItem in xmlList)
			{				
				rank = UtilXML.attributeIntValue(xmlItem, "rank");
				m_dicReward[rank]=UtilXML.attributeValue(xmlItem, "desc");
			}
		}
		
		//进入三国战场
		public function comeIn():void
		{
			m_bInZhanchang = true;
			m_gkContext.m_screenbtnMgr.hideUIScreenBtn();
			m_gkContext.m_taskMgr.hideUITaskTrace();
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskPrompt);
			m_gkContext.m_UIMgr.loadForm(UIFormID.UIGgzjWuList);
			m_gkContext.m_playerManager.heroDirect.updateNameDesc();			
		}
		//离开三国战场
		public function leave():void
		{
			m_bInZhanchang = false;
			m_bInJinGongJianGe = false;
			if (m_nextFightTime)
			{
				m_nextFightTime.dispose();
			}
			m_gkContext.m_screenbtnMgr.showUIScreenBtnAfterMapLoad();
			m_gkContext.m_taskMgr.showUITaskTrace();
			m_gkContext.m_UIMgr.showForm(UIFormID.UITaskPrompt);
			m_gkContext.m_UIMgr.destroyForm(UIFormID.UIGgzjWuList);
			m_gkContext.m_playerManager.heroDirect.updateNameDesc();
		}
		public function get zhenyingName():String
		{
			return s_zhenyingName(m_zhenying);			
		}
		
		public function get zhenying():int
		{
			return m_zhenying;
		}
		
		/*public function get timesOfEnterRemained():int
		{
			return maxTimes - m_timesOfEnter;
		}*/
		
		//剩余领奖次数
		public function get timesOfReward():int
		{
			if (m_timesOfEnter <= maxTimes)
			{
				return maxTimes - m_timesOfEnter;
			}
			return 0;
		}
		
		public function get maxTimes():int
		{
			return MAXCOUNTS_GOIN;
		}
		
		public function get inZhanchang():Boolean
		{
			return m_bInZhanchang;
		}
		
		public function isMyShouwei(npcID:uint):Boolean
		{
			var myShouID:uint;
			switch(zhenying)
			{
				case ZHENYING_Wei: myShouID = 11001; break;	//魏
				case ZHENYING_Shu: myShouID = 12001; break;	//蜀
				case ZHENYING_Wu: myShouID = 13001; break;	//吴
			}
			
			return myShouID == npcID;			
		}
		
		public function startFightTime():void//开始计时器
		{
			if (m_nextFightTime == null)
			{
				m_nextFightTime = new Daojishi(m_gkContext.m_context);
				m_nextFightTime.funCallBack = FightTimeCallBack;				
			}
			m_nextFightTime.initLastTime = m_inTimeRemain;//服务器返回战斗间隔
			m_nextFightTime.begin();
			
		}
		private function FightTimeCallBack(d:Daojishi):void
		{
			if (m_nextFightTime.isStop())
			{
				m_bInJinGongJianGe = false;
				m_nextFightTime.end();
				m_inTimeRemain = 0;
			}
			else
			{
				m_inTimeRemain = m_nextFightTime.timeSecond;
			}
			m_gkContext.playerMain.updateNameDesc();
		}
		public function get remainedFightTime():int
		{
			return m_inTimeRemain;
		}
		
		public function get bInJinGongJianGe():Boolean
		{
			return m_bInJinGongJianGe;
		}
		
		public function process7ClockUserCmd():void
		{
			m_timesOfEnter = 0;
			onTimesOfEnterUpdate();
		}
		
		public static function s_zhenyingName(id:int):String
		{
			var ret:String = "魏";
			switch(id)
			{
				case ZHENYING_Wei:ret = "魏"; break;
				case ZHENYING_Shu:ret = "蜀"; break;
				case ZHENYING_Wu:ret = "吴"; break;
			}
			return ret;
		}
		
		public static function s_idToTitleName(id:int):String
		{
			var ret:String = "士兵";
			switch(id)
			{
				case TITLE_ShiBing:ret = "士兵"; break;
				case TITLE_PianJiang:ret = "偏将"; break;
				case TITLE_daJiang:ret = "大将"; break;
				case TITLE_YuShuai:ret = "元帅"; break;
				case TITLE_QinWang:ret = "亲王"; break;
			}
			return ret;
		}
		
		
		
		
		
		
	}

}