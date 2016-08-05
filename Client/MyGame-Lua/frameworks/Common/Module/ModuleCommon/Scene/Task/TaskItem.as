package modulecommon.scene.task
{
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;

	import modulecommon.net.msg.questUserCmd.stQuestVarsUserCmd;
	import modulecommon.net.msg.questUserCmd.stRequestQuestUserCmd;
	import com.util.UtilHtml;
	import com.util.CmdParse;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TaskItem
	{
		public var m_ID:uint;
		public var m_iState:int;
		public var m_strName:String;
		public var m_strGoal:String;
		public var m_strGoalItem:String;
		public var m_rewardList:Array;
		public var m_strDesc:String;
		private var m_dicVars:Dictionary;
		private var m_fenbenIDs:Vector.<int>;
		
		public function TaskItem()
		{
			m_dicVars = new Dictionary();
			m_rewardList = new Array();
		}
		
		public function parseInfo(info:String):void
		{
			var xml:XML = new XML(info);
			var str:String;
			var i:int = 0;
			//解析  <description fubenid="54,34,65">
			if (xml.@fubenid.length() > 0)
			{
				str = xml.@fubenid;
				var ar:Array = str.split(",");
				
				m_fenbenIDs = new Vector.<int>(ar.length);
				for (i = 0; i < ar.length; i++)
				{
					m_fenbenIDs[i] = parseInt(ar[i] as String);
				}
			}
			if (xml.goal != undefined)
			{
				m_strGoal = xml.goal.toXMLString();
				m_strGoal = UtilHtml.removeWhitespace(m_strGoal);
			}
			else
			{
				m_strGoal = "";
			}
			
			if (xml.reward != undefined)
			{
				var list:XMLList = xml.reward.child("item");
				var param:String;
				for (i = 0; i < list.length(); i++)
				{
					param = list[i].@param;
					if (param)
					{
						m_rewardList.push(param);
					}
				}
			}
			if (xml.body != undefined)
			{
				m_strDesc = xml.body.toXMLString();
				m_strDesc = UtilHtml.removeWhitespace(m_strDesc);
			}
			else
			{
				m_strDesc = "";
			}
		
		}
		
		public function get taskType():int
		{
			return TaskManager.idToTaskType(m_ID);
		}
		
		//返回值:true-表示有变量变化了
		public function updateVars(rev:stQuestVarsUserCmd):Boolean
		{
			//if(rev.vars[state]
			var name:String;
			var oldState:int = m_iState;
			var bChange:Boolean = false;
			for (name in rev.vars)
			{
				if (name == "state")
				{
					var iState:int = parseInt(rev.vars[name]);
					if (m_iState != iState)
					{
						m_iState = iState;
						bChange = true;
					}					
				}
				else
				{
					if (m_dicVars[name] != rev.vars[name])
					{
						m_dicVars[name] = rev.vars[name];
						bChange = true;
					}
				}				
			}
			if (bChange)
			{
				generateGoalItem();
			}
			return bChange;
		}
		
		protected function generateGoalItem():void
		{
			var xml:XML = new XML(m_strGoal);
			var list:XMLList = xml.child("item");
			if (list.length() == 0)
			{
				m_strGoalItem = m_strGoal;
				return;
			}
			var i:int = 0;
			var condition:String;
			var bSatisfied:Boolean;
			var conditionList:XMLList;
			m_strGoalItem = null;
			for (i = 0; i < list.length(); i++)
			{
				conditionList = list[i].@condition;				
				if (conditionList.length() == 0)
				{
					m_strGoalItem = list[i].toXMLString();
					break;
				}
				else
				{
					condition = conditionList[0];
					var parse:CmdParse = new CmdParse();
					parse.parse(condition);
					var dic:Dictionary = parse.dic;
					var key:String;
					bSatisfied = true;
					for (key in dic)
					{
						if ("state" == key)
						{
							var iState:int = parse.getIntValue("state");
							if (iState != this.m_iState)
							{
								bSatisfied = false;
								break;
							}							
						}
						else
						{
							if (m_dicVars[key] != dic[key])
							{
								bSatisfied = false;
								break;
							}
						}
					}	
					
					if(bSatisfied)
					{
						m_strGoalItem = list[i].toXMLString();
						break;
					}
				}
			}
			
			if (m_strGoalItem != null)
			{
				m_strGoalItem = UtilHtml.removeWhitespace(m_strGoalItem);
			}
		}
		
		public function getVarValue(name:String):String
		{
			return m_dicVars[name];
		}
		
		public function submitTask(gk:GkContext):void
		{
			var str:String="交任务(ID="+this.m_ID+").";
			var value:String = m_dicVars["exec_finish"];
			if (value)
			{
				str += value;
				var ar:Array = value.split(",");
				if (ar.length == 2)
				{
					var send:stRequestQuestUserCmd = new stRequestQuestUserCmd();
					send.id = this.m_ID;
					send.target = ar[0];
					send.offset = parseInt(ar[1]);
					gk.sendMsg(send);
				}
			}
			
			DebugBox.addLog(str);
		}
		
		public function get finished():Boolean
		{
			return m_iState == TaskManager.TASKSTATE_FINISHED;
		}
		
		public function hasFunben(id:int):Boolean
		{
			if (m_fenbenIDs == null)
			{
				return false;
			}
			
			if (-1 == m_fenbenIDs.indexOf(id))
			{
				return false;
			}
			return true;
		}
		
		public function hasWordmap(id:int):Boolean
		{
			var xml:XML = new XML(m_strGoalItem);
			
			if (xml.@param == undefined)
			{
				return false;
			}
			var param:String = xml.@param;
			var parse:CmdParse = new CmdParse();
			parse.parse(param);
			if (parse.getIntValue("worldmapid") == id)
			{
				return true;
			}
			return false;
		}
		
		public function TaskVarsToString():String
		{
			var strRet:String="";
			var str:String;
			for(str in m_dicVars)
			{
				strRet += str + " =" + m_dicVars[str];
			}
			return strRet;
		}
	}

}