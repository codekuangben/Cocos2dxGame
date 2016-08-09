package modulecommon.scene.task
{
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.questUserCmd.*;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.GkContext;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUITask;
	import modulecommon.uiinterface.IUITaskJiequ;
	import modulecommon.uiinterface.IUIXuanShangRenWu;
	import modulecommon.scene.taskprompt.TaskPromptMgr;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TaskManager
	{
		public static const COLOR_WHITE:int = 1;
		public static const COLOR_GREEN:int = 2;
		public static const COLOR_BLUE:int = 3;
		public static const COLOR_PURPLE:int = 4;
		public static const COLOR_GOLD:int = 5;
		
		//奖励类型定义，用于quest.xml中脚本的编写
		public static const REWARD_EXP:String = "exp";
		public static const REWARD_MONEY:String = "money";
		public static const REWARD_JIANGHUN:String = "jianghun";	//将魂
		public static const REWARD_OBJECT:String = "object";
		public static const REWARD_CONTRIBUTION:String = "contribution";//军团贡献
		
		public static const TASKTYPE_NONE:uint = 0; //非法任务类型
		public static const TASKTYPE_JuQing:uint = 1; //剧情引导任务
		public static const TASKTYPE_Fenzhi:uint = 2; //分支类任务
		public static const TASKTYPE_XunHuan:uint = 3; //循环类任务
		public static const TASKTYPE_HuoDong:uint = 4; //活动类任务
		public static const TASKTYPE_Xuanshang:uint = 5; //悬赏类任务
		public static const TASKTYPE_Corps:uint = 6; //团任务
		
		public static const TASKTYPE_MAX:uint = 6; //最大类型
		
		public static const TASKSTATE_FINISHED:int = -3;
		public static const TASKSTATE_Submit:int = -1;
		public static const TASKSTATE_Submit2:int = -2;
		
		public static const XUANSHANG_MAXCOUNT:uint = 20; //悬赏任务每日可完成最大次数
		
		private var m_gkContext:GkContext;
		private var m_dicTasks:Dictionary;
		private var m_dicFfunc:Dictionary;
		private var m_receivedCount:uint; //已接取悬赏任务次数
		private var m_bnoQuery:Boolean = false; //悬赏任务消费元宝是否提示 true-无提示 false-有提示
		
		public var m_bInCorpsTaskAni:Boolean = false; //true - 接到军团任务时，先不在任务追踪中显示，要等到老虎机转动结束后，再添加到任务追踪中
		private var m_bCorpsTaskID:uint;
		private var m_cycleQuestIndex:int;	//zero-based 当前正在做的循环任务的索引
		private var m_cycleQuestMax:int;	//循环任务的最大数量
		
		public function TaskManager(gkCon:GkContext)
		{
			m_gkContext = gkCon;
			m_dicTasks = new Dictionary();
			m_dicTasks[TASKTYPE_JuQing] = new Array();
			m_dicTasks[TASKTYPE_Fenzhi] = new Array();
			m_dicTasks[TASKTYPE_XunHuan] = new Array();
			m_dicTasks[TASKTYPE_HuoDong] = new Array();
			m_dicTasks[TASKTYPE_Xuanshang] = new Array();
			m_dicTasks[TASKTYPE_Corps] = new Array();
			
			m_dicFfunc = new Dictionary();
			m_dicFfunc[QuestUserParam.QUEST_INFO_PARA] = addQuest;
			m_dicFfunc[QuestUserParam.QUEST_VARS_PARA] = updateQuestVar;
			m_dicFfunc[QuestUserParam.ABANDON_QUEST_PARA] = deleteQuest;
			m_dicFfunc[QuestUserParam.SYN_QUEST_DATA_FIN_PARA] = endQuest;
			
			m_dicFfunc[QuestUserParam.RET_GET_XUAN_SHANG_QUEST_PARA] = processRetGetXuanShangQuestCmd;
			m_dicFfunc[QuestUserParam.RET_OPEN_XUAN_SHANG_QUEST_PARA] = processRetOpenXuanShangQuestCmd;
			m_dicFfunc[QuestUserParam.RET_REFRESH_XUAN_SHANG_QUEST_PARA] = processXuanshangDataUpdateCmd;
			m_dicFfunc[QuestUserParam.REFRESH_XUAN_SHANG_QUEST_STATE_PARA] = processXuanshangDataUpdateCmd;
			m_dicFfunc[QuestUserParam.NOTIFY_CYCLE_QUEST_NUM_PARA] = process_notifyCycleQuestNumCmd;
		}
		
		public function clear():void
		{
			m_dicTasks[TASKTYPE_JuQing].length = 0;
			m_dicTasks[TASKTYPE_JuQing].length = 0;
			m_dicTasks[TASKTYPE_XunHuan].length = 0;
			m_dicTasks[TASKTYPE_HuoDong].length = 0;
			m_dicTasks[TASKTYPE_Xuanshang].length = 0;
			m_dicTasks[TASKTYPE_Corps].length = 0;
		}
		
		public function getTaskItemInArray(ar:Array, id:uint):TaskItem
		{
			var index:uint = 0;
			for (index = 0; index < ar.length; index++)
			{
				if (ar[index].m_ID == id)
				{
					return ar[index];
				}
			}
			return null;
		}
		
		public function getTaskItemIndexInArray(ar:Array, id:uint):uint
		{
			var index:uint = 0;
			for (index = 0; index < ar.length; index++)
			{
				if (ar[index].m_ID == id)
				{
					return index;
				}
			}
			return uint.MAX_VALUE;
		}
		
		public function getTaskItem(id:uint):TaskItem
		{
			var type:uint = idToTaskType(id);
			if (type == TASKTYPE_NONE)
			{
				return null;
			}
			return getTaskItemInArray(m_dicTasks[type], id);
		}
		
		public function getTaskListByType(type:uint):Array
		{
			return m_dicTasks[type];
		}
		
		public function getCorpsTaskItem():TaskItem
		{
			var list:Array = m_dicTasks[TASKTYPE_Corps];
			if (list.length)
			{
				return list[0];
			}
			return null;
		}
		
		public function addQuest(msg:ByteArray, param:uint = 0):void
		{
			var rev:stQuestInfoUserCmd = new stQuestInfoUserCmd();
			rev.deserialize(msg);
			var type:uint = idToTaskType(rev.id);
			if (type == TASKTYPE_NONE)
			{
				return;
			}
			
			var taskItem:TaskItem;
			taskItem = getTaskItem(rev.id);
			if (taskItem != null)
			{
				return;
			}
			
			taskItem = new TaskItem();
			taskItem.m_ID = rev.id;
			taskItem.m_strName = rev.name;
			taskItem.parseInfo(rev.info);
			m_dicTasks[type].push(taskItem);
			
			if (m_gkContext.m_UIs.task)
			{
				m_gkContext.m_UIs.task.onAddTask(rev.id);
			}
			
			var bInCorpsTaskAni:Boolean = false;
			if (m_bInCorpsTaskAni && taskItem.taskType == TASKTYPE_Corps)
			{
				if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UITaskJiequ))
				{
					bInCorpsTaskAni = true;
				}
			}
			
			if (bInCorpsTaskAni == false)
			{
				if (m_gkContext.m_UIs.taskTrace)
				{
					m_gkContext.m_UIs.taskTrace.addTask(rev.id);
				}
			}
			else
			{
				m_bCorpsTaskID = rev.id;
			}
		}
		
		public function set inCorpsTaskAni(b:Boolean):void
		{
			if (m_bInCorpsTaskAni == b)
			{
				return;
			}
			m_bInCorpsTaskAni = b;
			
			if (m_bInCorpsTaskAni == false) //动画结束
			{
				if (m_gkContext.m_UIs.taskTrace &&m_bCorpsTaskID)
				{
					m_gkContext.m_UIs.taskTrace.addTask(m_bCorpsTaskID);
				}
				m_bInCorpsTaskAni = false;
				m_bCorpsTaskID = 0;
			}
		}
		
		public function test(item:TaskItem):void
		{
			var type:uint = idToTaskType(item.m_ID);
			if (type == TASKTYPE_NONE)
			{
				return;
			}
			m_dicTasks[type].push(item);
			
			if (m_gkContext.m_UIs.task)
			{
				m_gkContext.m_UIs.task.onAddTask(item.m_ID);
			}
			if (m_gkContext.m_UIs.taskTrace)
			{
				m_gkContext.m_UIs.taskTrace.addTask(item.m_ID);
			}
		}
		
		public function deleteQuest(msg:ByteArray, param:uint = 0):void
		{
			var rev:stAbandonQuestUserCmd = new stAbandonQuestUserCmd();
			rev.deserialize(msg);
			m_gkContext.addLog("删除任务："+rev.id);
			var type:uint = idToTaskType(rev.id);
			if (type == TASKTYPE_NONE)
			{
				return;
			}
			
			var taskList:Array = m_dicTasks[type];
			var index:uint = getTaskItemIndexInArray(taskList, rev.id);
			if (uint.MAX_VALUE == index)
			{
				return;
			}
			taskList.splice(index, 1);
			
			if (m_gkContext.m_UIs.task)
			{
				m_gkContext.m_UIs.task.onDeleteTask(rev.id);
			}
			if (m_gkContext.m_UIs.taskTrace)
			{
				m_gkContext.m_UIs.taskTrace.deleteTask(rev.id);
			}
			
			if (type == TASKTYPE_Corps)
			{
				var uiCorpsTaskJiequ:IUITaskJiequ = m_gkContext.m_UIMgr.getForm(UIFormID.UITaskJiequ) as IUITaskJiequ;
				if (uiCorpsTaskJiequ && uiCorpsTaskJiequ.isVisible())
				{
					uiCorpsTaskJiequ.freshForm();
				}
			}
		}
		
		public function updateQuestVar(msg:ByteArray, param:uint = 0):void
		{
			var rev:stQuestVarsUserCmd = new stQuestVarsUserCmd();
			rev.deserialize(msg);
			var taskItem:TaskItem = getTaskItem(rev.id);
			if (taskItem == null)
			{
				return;
			}
			if (taskItem)
			{
				if (taskItem.updateVars(rev) == false)
				{
					return;
				}
				
				if (taskItem.m_iState == TaskManager.TASKSTATE_Submit || taskItem.m_iState == TaskManager.TASKSTATE_Submit2)
				{
					if (m_gkContext.m_UIs.hero)
					{
						m_gkContext.m_UIs.hero.showTaskAni();
						// 播放音效
						m_gkContext.m_commonProc.playMsc(11);
					}
					
					if (taskItem.taskType == TaskManager.TASKTYPE_Corps)
					{
						var uiCorpsTaskJiequ:IUITaskJiequ = m_gkContext.m_UIMgr.getForm(UIFormID.UITaskJiequ) as IUITaskJiequ;
						if (uiCorpsTaskJiequ && uiCorpsTaskJiequ.isVisible())
						{
							uiCorpsTaskJiequ.freshForm();
						}
						else
						{
							m_gkContext.m_corpsMgr.openForm(UIFormID.UITaskJiequ);
						}
					}
				}
			}
			if (m_gkContext.m_UIs.task)
			{
				m_gkContext.m_UIs.task.onUpdateVar(rev.id);
			}
			if (m_gkContext.m_UIs.taskTrace)
			{
				m_gkContext.m_UIs.taskTrace.updateTask(rev.id);
			}
			if (m_gkContext.m_UIs.xuanshangrenwu)
			{
				m_gkContext.m_UIs.xuanshangrenwu.onUpdateVar(rev.id);
			}
		}
		
		public function endQuest(msg:ByteArray, param:uint = 0):void
		{			
			//m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITaskTrace);//移到SceneUserProcess.as::processSynOnlineFinDataUsercmd()中创建
		}
		
		public function handleMsg(msg:ByteArray, param:uint = 0):void
		{
			if (m_dicFfunc[param] != undefined)
			{
				m_dicFfunc[param](msg, param);
			}
		}
		
		public function getAllTasks():Array
		{
			var ret:Array = new Array();
			for each (var ar:*in m_dicTasks)
			{
				ret = ret.concat((ar as Array));
			}
			return ret;
		}
		
		/*
		 * 判断副本是否与某个的任务相关。
		 * 输入:fubenID - 副本ID
		 * 输出:true - 与某个任务相关
		 * 输出：false - 没有任务与这个副本相关
		 */
		public function isTaskFunben(fubenID:uint):Boolean
		{
			var tasks:Array;
			var index:int;
			for each (tasks in m_dicTasks)
			{
				for (index = 0; index < tasks.length; index++)
				{
					if ((tasks[index] as TaskItem).hasFunben(fubenID))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/*
		 * 判断世界地图是否与某个的任务相关。
		 * 输入:fubenID - 副本ID
		 * 输出:true - 与某个任务相关
		 * 输出：false - 没有任务与这个副本相关
		 */
		public function isTaskworldmap(worldmapid:uint):Boolean
		{
			var tasks:Array;
			var index:int;
			for each (tasks in m_dicTasks)
			{
				for (index = 0; index < tasks.length; index++)
				{
					if ((tasks[index] as TaskItem).hasWordmap(worldmapid))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public static function idToTaskType(id:uint):uint
		{
			var type:uint = TASKTYPE_JuQing;
			if (id >= 10000 && id <= 19999)
			{
				type = TASKTYPE_JuQing;
			}
			else if (id >= 100 && id <= 999)
			{
				type = TASKTYPE_Xuanshang;
			}
			else if (id >= 1000 && id <= 1999)
			{
				type = TASKTYPE_Corps;
			}
			else if (id >= 20000 && id <= 29999)
			{
				type = TASKTYPE_Fenzhi;
			}
			else if (id >= 40000 && id <= 59999)
			{
				type = TASKTYPE_XunHuan;
			}
			else //if (id >= 40010 && id <= 49999)
			{
				type = TASKTYPE_HuoDong;
			}
			return type;
		}
		
		public function get receivedCount():uint
		{
			return m_receivedCount;
		}
		
		public function set receivedCount(count:uint):void
		{
			m_receivedCount = count;
		}
		
		private function processRetGetXuanShangQuestCmd(msg:ByteArray, param:uint = 0):void
		{
			var rev:stRetGetXuanShangQuestUserCmd = new stRetGetXuanShangQuestUserCmd();
			rev.deserialize(msg);
			
			m_receivedCount = rev.count;
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIXuanShangRenWu) as IForm;
			if (form)
			{
				form.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_XuanshangRenwu, -1, (XUANSHANG_MAXCOUNT - m_receivedCount));
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(XUANSHANG_MAXCOUNT - m_receivedCount, ScreenBtnMgr.Btn_Xuanshangrenwu);
			}
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			receivedCount = 0;		
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIXuanShangRenWu) as IForm;
			if (form)
			{
				form.updateData();
			}
			
			if (m_gkContext.m_UIs.taskPrompt)
			{
				m_gkContext.m_UIs.taskPrompt.updateLeftCountsAddTimes(TaskPromptMgr.TASKPROMPT_XuanshangRenwu, -1, (XUANSHANG_MAXCOUNT - m_receivedCount));
			}
			
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateLblCnt(XUANSHANG_MAXCOUNT - m_receivedCount, ScreenBtnMgr.Btn_Xuanshangrenwu);
			}
		}
		
		//更新变量值
		public function processTaskDesc(taskItem:TaskItem, desc:String):String
		{
			//任务变量赋值
			var xml:XML = new XML(desc);
			var varList:XMLList = xml.descendants("var");
			var name:String;
			var value:String;
			for each (var item:XML in varList)
			{
				name = item.@name;
				value = taskItem.getVarValue(name);
				if (value == null)
				{
					value = "0";
					
				}
				item.appendChild(value);
				
			}
			var strXml:String = xml.toXMLString();
			//去掉空白符
			
			var newStr:String;
			
			newStr = UtilHtml.removeWhitespace(strXml);
			
			return newStr;
		}
		
		//更新变量值
		public function processTaskDescByID(id:uint, desc:String):String
		{
			var taskItem:TaskItem = this.getTaskItem(id);
			if (taskItem == null)
			{
				return desc;
			}
			return processTaskDesc(taskItem, desc);
		}
		
		//当未接取该任务时，将任务描述中的变量值设为0(bMax==false)，或最大值(bMax==true)
		public function processTaskDescVarWithoutThisTask(desc:String, bMax:Boolean):String
		{
			//任务变量赋值
			var xml:XML = new XML(desc);
			var varList:XMLList = xml.descendants("var");
			var name:String;
			var value:String;
			var maxValue:XMLList;
			for each (var item:XML in varList)
			{
				if (bMax == false)
				{
					item.appendChild("0");
				}
				else
				{
					maxValue = item.@maxvalue;
					if (maxValue.length() > 0)
					{
						item.appendChild(maxValue[0]);
					}
				}
			}
			var strXml:String = xml.toXMLString();
			//去掉空白符
			
			var newStr:String;
			
			newStr = UtilHtml.removeWhitespace(strXml);
			
			return newStr;
		}
		
		private function processRetOpenXuanShangQuestCmd(msg:ByteArray, param:uint = 0):void
		{
			m_gkContext.m_contentBuffer.addContent("UIXuanShangRenWuOpen_UIInfo", msg);
			
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UIXuanShangRenWu);
		}
		
		private function processXuanshangDataUpdateCmd(msg:ByteArray, param:uint = 0):void
		{
			var obj:Object = new Object();
			obj["msg"] = msg;
			obj["param"] = param;
			m_gkContext.m_contentBuffer.addContent("UIXuanShangRenWuUpdate_UIInfo", obj);
			
			var form:IForm = m_gkContext.m_UIMgr.getForm(UIFormID.UIXuanShangRenWu) as IForm;
			if (form)
			{
				form.updateData();
			}
		}
		private function process_notifyCycleQuestNumCmd(msg:ByteArray, param:uint = 0):void
		{
			var rev:notifyCycleQuestNumCmd = new notifyCycleQuestNumCmd();
			rev.deserialize(msg);
			m_cycleQuestIndex = rev.num;
			m_cycleQuestMax = rev.max;
			if (m_gkContext.m_UIs.taskTrace)
			{
				m_gkContext.m_UIs.taskTrace.updateXunhuanTaskIndex();
			}
		}
		//根据任务名称，取得相应任务对象，用于调试
		public function getTaskItemByNameMatch(name:String):Array
		{
			var list:Array;
			var taskItem:TaskItem;
			var retList:Array = new Array();
			for each (list in m_dicTasks)
			{
				for each (taskItem in list)
				{
					if (taskItem.m_strName.search(name) != -1 || taskItem.m_strGoal.search(name) != -1)
					{
						retList.push(taskItem);
					}
				}
			}
			
			return retList;
		}
		
		public function set bnoQuery(bool:Boolean):void
		{
			m_bnoQuery = bool;
		}
		
		public function get bnoQuery():Boolean
		{
			return m_bnoQuery;
		}
		public function get cycleQuestIndex():int
		{
			return m_cycleQuestIndex;
		}
		public function get cycleQuestMax():int
		{
			return m_cycleQuestMax;
		}
		
		//return true-当前应该显示任务追踪
		public function isShouldShowUITaskTrace():Boolean
		{
			var ret:Boolean=true;		
			if (m_gkContext.m_arenaMgr.isInArenea || m_gkContext.m_elitebarrierMgr.m_bInJBoss || m_gkContext.m_ggzjMgr.inMap||
			m_gkContext.m_mapInfo.m_bInSGQYH || m_gkContext.m_worldBossMgr.m_bInWBoss || m_gkContext.m_sanguozhanchangMgr.inZhanchang ||
			m_gkContext.m_teamFBSys.bInMap)
			{
				ret = false;
			}
			return ret;
		}
		
		public function hideUITaskTrace():void
		{			
			m_gkContext.m_UIMgr.hideForm(UIFormID.UITaskTrace);			
		}
		
		public function showUITaskTrace():void
		{
			m_gkContext.m_UIMgr.showFormWidthNoProgress(UIFormID.UITaskTrace);
		}
	}

}