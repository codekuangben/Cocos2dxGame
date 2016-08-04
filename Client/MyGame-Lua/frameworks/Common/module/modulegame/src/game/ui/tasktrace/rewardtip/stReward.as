package game.ui.tasktrace.rewardtip
{
	import com.util.CmdParse;
	import modulecommon.GkContext;
	import modulecommon.scene.task.TaskItem;
	import modulecommon.scene.task.TaskManager;
	
	/**
	 * ...
	 * @author
	 */
	public class stReward
	{
		public var exp:uint;
		public var yinbi:uint;
		public var contribution:uint;
		public var jianghun:uint;
		public var m_list:Vector.<stObjectData>;
		
		public function clear():void
		{
			exp = 0;
			yinbi = 0;
			contribution = 0;
			jianghun = 0;
			m_list = new Vector.<stObjectData>();
		}
		public function parse(gk:GkContext, taskItem:TaskItem):void
		{
			var i:int = 0;
			var cmd:CmdParse;
			var iData:int;
			clear();
			
			var list:Array = taskItem.m_rewardList;
			for (i = 0; i < list.length; i++)
			{
				cmd = new CmdParse();
				cmd.parse(list[i] as String);
				if (cmd.cmd == TaskManager.REWARD_EXP || cmd.cmd == TaskManager.REWARD_MONEY || cmd.cmd == TaskManager.REWARD_CONTRIBUTION  || cmd.cmd == TaskManager.REWARD_JIANGHUN)
				{
					var value:String = cmd.getValue("value");
					if (value == null)
					{
						var varName:String = cmd.getValue("var");
						if (varName)
						{
							value = taskItem.getVarValue(varName);
						}
					}
					if (value==null)
					{
						value="";
					}
					iData = parseInt(value);
					if (cmd.cmd == TaskManager.REWARD_MONEY)
					{
						yinbi = iData;						
					}					
					else if (cmd.cmd == TaskManager.REWARD_EXP)
					{
						exp = iData;
					}		
					else if (cmd.cmd == TaskManager.REWARD_CONTRIBUTION)
					{
						contribution = iData;
					}
					else if (cmd.cmd == TaskManager.REWARD_JIANGHUN)
					{
						jianghun = iData;
					}
				}
				else if (cmd.cmd == TaskManager.REWARD_OBJECT)
				{
					var objData:stObjectData = new stObjectData();
					objData.m_id = cmd.getIntValue("id");
					objData.m_num = cmd.getIntValue("num");
					if (objData.m_num==0)
					{
						objData.m_num = 1;
					}
					m_list.push(objData);					
				}
			}
		
		}
	
	}
}