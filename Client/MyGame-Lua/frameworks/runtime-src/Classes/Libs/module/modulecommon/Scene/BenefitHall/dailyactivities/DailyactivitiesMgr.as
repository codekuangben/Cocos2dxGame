package modulecommon.scene.benefithall.dailyactivities 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import com.util.UtilCommon;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.GkContext;
	import modulecommon.net.msg.dailyactivitesCmd.stGetPerDayActiveUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stOpenPerDayToDoUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stPerDayToDoUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.stPerDayValueUserCmd;
	import modulecommon.net.msg.dailyactivitesCmd.ToDoItem;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIBenefitHall;
	import modulecommon.scene.benefithall.IBenefitSubSystem;
	/**
	 * ...
	 * @author ...
	 * 每日必做:每日活动 + 打卡
	 */
	public class DailyactivitiesMgr implements IBenefitSubSystem
	{
		//赋值对应 meiribizuo.xml中huoyue-id
		public static const TODOS_ITEM11:int = 11;	//赌博达人
		public static const TODOS_ITEM12:int = 12;	//抢夺豪杰
		public static const TODOS_ITEM13:int = 13;	//竞技场常客
		public static const TODOS_ITEM14:int = 14;	//精英BOSS克星
		public static const TODOS_ITEM15:int = 15;	//藏宝窟杀手
		public static const TODOS_ITEM16:int = 16;	//过关斩将王
		public static const TODOS_ITEM17:int = 17;	//世界BOSS
		public static const TODOS_ITEM18:int = 18;	//军团战参与(王城争霸)
		public static const TODOS_ITEM19:int = 19;	//招财福星
		public static const TODOS_ITEM20:int = 20;	//悬赏达成
		public static const TODOS_ITEM21:int = 21;	//VIP土豪
		public static const TODOS_ITEM22:int = 22;	//无私捐献
		public static const TODOS_ITEM23:int = 23;	//军团任务
		public static const TODOS_ITEM24:int = 24;	//组队副本
		public static const TODOS_ITEM25:int = 25;	//三国战场
		public static const TODOS_ITEM26:int = 26;	//组队BOSS
		public static const TODOS_ITEM27:int = 27;	//骑术培养
		
		
		private var m_gkContext:GkContext;
		private var m_reg:uint;		//签到记录
		public var m_regCounts:uint;	//累计签到次数
		public var m_actValue:uint;		//今日活跃值
		public var m_fenVec:Array;	//这个分值对应宝箱未领(即现在可以领取奖励)
		public var m_hasDatas:Boolean;		//是否已经读取数据
		public var m_dicTodo:Dictionary;
		public var m_actRewardList:Array;	//活跃奖励
		public var m_dicRegReward:Dictionary;	//签到奖励
		public var m_regValueVec:Vector.<uint>;	//签到奖励段 如:2,5,10,17,26
		public var m_todoList:Array;	//活跃任务进度 id:编号 counts:做了几次
		
		public function DailyactivitiesMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_fenVec = new Array();
			m_dicTodo = new Dictionary();
			m_actRewardList = new Array();
			m_dicRegReward = new Dictionary();
			m_regValueVec = new Vector.<uint>();
		}
		
		public function loadConfig():void
		{
			if (m_hasDatas == true)
			{
				return;
			}
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Meiribizuo);
			if (xml)
			{
				parseXml(xml);
				m_hasDatas = true;
			}
		}
		
		private function parseXml(xml:XML):void
		{
			var constellationList:XMLList;
			var item:XML;
			
			//活跃任务
			constellationList = xml.child("huoyue");
			var itemtodo:ItemToDo;
			for each(item in constellationList)
			{
				itemtodo = new ItemToDo();
				itemtodo.parseXml(item);
				
				m_dicTodo[itemtodo.m_id] = itemtodo;
			}
			
			//活跃度奖励
			constellationList = xml.child("item");
			var actreward:ActReward;
			for each(item in constellationList)
			{
				actreward = new ActReward();
				actreward.parseXml(item);
				actreward.setLevel(parseInt(item.@level1), parseInt(item.@level2));
				
				m_actRewardList.push(actreward);
			}
			
			//签到奖励
			constellationList = xml.child("ci");
			var regreward:RegReward;
			var levelXmlList:XMLList;
			var levelList:Array;
			var value:uint;
			for each(item in constellationList)
			{
				levelXmlList = item.child("item");
				levelList = new Array();
				for each(var levelxml:XML in levelXmlList)
				{
					regreward = new RegReward();
					regreward.parseXml(levelxml);
					
					levelList.push(regreward);
				}
				
				value = parseInt(item.@num);
				m_regValueVec.push(value);
				m_dicRegReward[value] = levelList;
			}
		}
		
		public function setReg(day:uint):void
		{
			m_reg = UtilCommon.setStateUint(m_reg, day);
		}
		
		public function isReg(day:uint):Boolean
		{
			return UtilCommon.isSetUint(m_reg, day);
		}
		
		//通知每日活跃值
		public function processPreDayValueUserCmd(msg:ByteArray):void
		{
			var rev:stPerDayValueUserCmd = new stPerDayValueUserCmd();
			rev.deserialize(msg);
			m_actValue = rev.activeValue;
			
			m_fenVec.length = 0;
			for (var i:int = 0; i < 4; i++)
			{
				if (rev.fenVec[i])
				{
					m_fenVec.push(rev.fenVec[i]);
				}
			}
			
			var iuibenefithall:IUIBenefitHall = m_gkContext.m_UIMgr.getForm(UIFormID.UIBenefitHall) as IUIBenefitHall;
			if (iuibenefithall)
			{
				iuibenefithall.updateDataOnePage(BenefitHallMgr.BUTTON_HuoyueFuli);
			}
			
			if (hasReward(BenefitHallMgr.BUTTON_HuoyueFuli))
			{
				notify_hasReward(BenefitHallMgr.BUTTON_HuoyueFuli);
			}
			else
			{
				notify_noReward(BenefitHallMgr.BUTTON_HuoyueFuli);
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Action, -1, m_actValue);
			}
		}
		
		//收到签到、活跃任务数据信息
		public function processpreDayToDoUserCmd(msg:ByteArray):void
		{
			var rev:stPerDayToDoUserCmd = new stPerDayToDoUserCmd();
			rev.deserialize(msg);
			
			m_reg = rev.reg;
			m_regCounts = rev.count;
			m_todoList = rev.todoList;
			
			var iuibenefithall:IUIBenefitHall = m_gkContext.m_UIMgr.getForm(UIFormID.UIBenefitHall) as IUIBenefitHall;
			if (iuibenefithall)
			{
				iuibenefithall.updateDataOnePage(BenefitHallMgr.BUTTON_MeiriQiandao);
				iuibenefithall.updateDataOnePage(BenefitHallMgr.BUTTON_HuoyueFuli);
			}
		}
		
		//获得当前活跃任务列表
		public function getCurToDoList():Array
		{
			var ret:Array;
			var i:int;
			if (m_todoList)
			{
				ret = new Array();
				var todoitem:ToDoItem;
				var itemtodo:ItemToDo;
				for (i = 0; i < m_todoList.length; i++)
				{
					todoitem = m_todoList[i];
					itemtodo = m_dicTodo[todoitem.id];
					if (itemtodo)
					{
						itemtodo.m_curCounts = todoitem.count;
						ret.push(itemtodo);
					}
				}
				ret.sort(compare);
			}
			
			return ret;
		}
		
		//活跃任务次数已完成的放到后边
		private function compare(a:ItemToDo, b:ItemToDo):int
		{
			if (true == a.bCompleted && false == b.bCompleted)
			{
				return 1;
			}
			else if (a.bCompleted == b.bCompleted)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		}
		
		//获得当前活跃度奖励
		public function getCurActReward():Array
		{
			var ret:Array;
			var level:uint;
			
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			else
			{
				return ret;
			}
			
			var i:int;
			var j:int;
			var item:ActReward;
			var reward:Rewards;
			var value:uint;
			for (i = 0; i < m_actRewardList.length; i++)
			{
				item = m_actRewardList[i];
				if (item.m_level.x <= level && level <= item.m_level.y)
				{
					ret = new Array();
					for (j = 0; j < item.m_valueVec.length; j++)
					{
						reward = new Rewards();
						value = item.m_valueVec[j];
						reward.setDatas(value, item.m_dicActLevel[value]);
						reward.m_bReceive = false;
						
						if (m_actValue >= value)
						{
							reward.m_bReceive = true;
							
							for each(var v:uint in m_fenVec)
							{
								if (value == v)
								{
									reward.m_bReceive = false;
								}
							}
						}
						
						ret.push(reward);
					}
					
					return ret;
				}
			}
			
			return ret;
		}
		
		//获得当前签到奖励
		public function getCurRegReward():Array
		{
			var ret:Array = new Array();
			var level:uint;
			
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			else
			{
				return ret;
			}
			
			var i:int;
			var j:int;
			var list:Array;
			var item:RegReward;
			var reward:Rewards;
			var value:uint;
			for (i = 0; i < m_regValueVec.length; i++)
			{
				value = m_regValueVec[i];
				list = m_dicRegReward[value] as Array;
				for (j = 0; j < list.length; j++)
				{
					item = list[j] as RegReward;
					if (item && (item.m_level.x <= level) && (level <= item.m_level.y))
					{
						reward = new Rewards();
						reward.setDatas(value, item.m_propslist);
						if (value <= m_regCounts)
						{
							reward.m_bReceive = true;
						}
						ret.push(reward);
						break;
					}
				}
			}
			
			return ret;
		}
		
		//领取每日获得宝箱奖励 
		public function getPerDayActiveRewards(list:Array = null):void
		{
			var cmd:stGetPerDayActiveUserCmd = new stGetPerDayActiveUserCmd();
			var i:int;
			
			if (null == list)
			{
				list = m_fenVec;
			}
			
			for (i = 0; i < list.length; i++)
			{
				cmd.fenVec[i] = list[i];
			}
			m_gkContext.sendMsg(cmd);
		}
		
		//每个任务对应功能界面 id:活跃任务编号   return:对应SysNewFeatures中功能编号
		public static function getFuncID(id:int):int
		{
			var funcid:int;
			
			switch(id)
			{
				case TODOS_ITEM11:
					funcid = SysNewFeatures.FUNC_GAMBLE;
					break;
				case TODOS_ITEM12:
					funcid = SysNewFeatures.FUNC_JIUGUANPURPLE;
					break
				case TODOS_ITEM13:
					funcid = SysNewFeatures.NFT_JINGJICHANG;
					break;
				case TODOS_ITEM14:
					funcid = SysNewFeatures.NFT_ZHANYITIAOZHAN;
					break;
				case TODOS_ITEM15:
					funcid = SysNewFeatures.NFT_CANBAOKU;
					break;
				case TODOS_ITEM16:
					funcid = SysNewFeatures.NFT_TRIALTOWER;
					break;
				case TODOS_ITEM17:
					funcid = SysNewFeatures.NFT_WORLDBOSS;
					break;
				case TODOS_ITEM18:
					funcid = SysNewFeatures.NFT_CITYBATTLE;
					break;
				case TODOS_ITEM19:
					funcid = SysNewFeatures.NFT_CAISHENDAO;
					break;
				case TODOS_ITEM20:
					funcid = SysNewFeatures.NFT_XUANSHANG;
					break;
				case TODOS_ITEM21:
					funcid = 0;
					break;
				case TODOS_ITEM22:
				case TODOS_ITEM23:
					funcid = SysNewFeatures.NFT_JUNTUAN;
					break;
				case TODOS_ITEM24:
				case TODOS_ITEM26:
					funcid = SysNewFeatures.NFT_TEAMCOPY;
					break;
				case TODOS_ITEM25:
					funcid = SysNewFeatures.NFT_SANGUOZHANCHANG;
					break;
				case TODOS_ITEM27:
					funcid = SysNewFeatures.NFT_MOUNT;
					break;
			}
			
			return funcid;
		}
		
		//获得当前等级每日活跃度最大值
		public function get actValueMax():uint
		{
			var ret:uint = 0;			
			var itemtodo:ItemToDo;
			var id:int;
			var actreward:ActReward = actRewardInCurLevel;
			
			if (actreward)
			{
				for each(id in actreward.m_todoList)
				{
					itemtodo = m_dicTodo[id];
					if (itemtodo)
					{
						ret += itemtodo.m_value;
					}
				}
			}
			
			return ret;
		}
		
		//获得今日已完成活跃任务数量
		public function get numHavedActiveTodo():uint
		{
			var ret:uint;
			var list:Array = getCurToDoList();
			var itemtodo:ItemToDo;
			for each(itemtodo in list)
			{
				if (itemtodo.bCompleted)
				{
					ret++;
				}
			}
			
			return ret;
		}
		
		//获得当前等级段活动任务数据信息
		public function get actRewardInCurLevel():ActReward
		{
			var ret:ActReward;
			var level:uint;
			
			if (m_gkContext.playerMain)
			{
				level = m_gkContext.playerMain.level;
			}
			else
			{
				return ret;
			}
			
			var actreward:ActReward;
			
			for each(actreward in m_actRewardList)
			{
				if (actreward.m_level.x <= level && level <= actreward.m_level.y)
				{
					ret = actreward;
					break;
				}
			}
			
			return ret;
		}
		
		//获得下一阶段活跃度值
		public function getNextActRewardFen():uint
		{
			var ret:uint;
			var valuevec:Vector.<uint>;
			var i:int;
			var actreward:ActReward = actRewardInCurLevel;
			
			if (actreward)
			{
				valuevec = actreward.m_valueVec;
			}
			
			if (valuevec && valuevec.length)
			{
				for (i = 0; i < valuevec.length; i++)
				{
					if (m_actValue < valuevec[i])
					{
						ret = valuevec[i];
						break;
					}
				}
				
				if (i == valuevec.length)
				{
					ret = valuevec[i - 1];
				}
			}
			
			return ret;
		}
		
		//打开每日必做功能界面
		public function reqOpenPerDayToDo():void
		{
			var cmd:stOpenPerDayToDoUserCmd = new stOpenPerDayToDoUserCmd();
			m_gkContext.sendMsg(cmd);
			
			loadConfig();
		}
		
		//获得某一阶段活跃度奖励  value:活跃度值
		public function getActRewards(value:uint):Rewards
		{
			var list:Array = getCurActReward();
			var rewards:Rewards;
			for each(rewards in list)
			{
				if (rewards.m_value == value)
				{
					return rewards;
				}
			}
			
			return null;
		}
		
		public function process7ClockUserCmd():void
		{
			//活跃度值:次日重置为0
			m_actValue = 0;
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_Action, -1, m_actValue);
			}
		}
		
		//0点签到重置
		public function process0ClockuserCmd():void
		{
			m_gkContext.m_sysOptions.clear(SysOptions.COMMONSET_REG)
			updateCommonsetReg();
			
			var iuibenefithall:IUIBenefitHall = m_gkContext.m_UIMgr.getForm(UIFormID.UIBenefitHall) as IUIBenefitHall;
			if (iuibenefithall)
			{
				iuibenefithall.updateDataOnePage(BenefitHallMgr.BUTTON_MeiriQiandao);
			}
		}
		
		//签到信息重置(今日是否已签到)//活动按钮特效更新
		public function updateCommonsetReg():void
		{
			if (hasReward(BenefitHallMgr.BUTTON_MeiriQiandao))
			{
				notify_hasReward(BenefitHallMgr.BUTTON_MeiriQiandao);
			}
			else
			{
				notify_noReward(BenefitHallMgr.BUTTON_MeiriQiandao);
			}
		}
		
		public function hasReward(id:int):Boolean
		{
			var ret:Boolean = false;
			
			if (BenefitHallMgr.BUTTON_HuoyueFuli == id)
			{
				if (m_fenVec.length)
				{
					ret = true;
				}
			}
			else if ((BenefitHallMgr.BUTTON_MeiriQiandao == id) && !m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_REG))
			{
				for each(var value:uint in m_regValueVec)
				{
					if ((m_regCounts + 1) == value)
					{
						ret = true;
						break;
					}
				}
			}
			
			return ret;
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