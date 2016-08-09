package modulecommon.scene.taskprompt 
{
	/**
	 * ...
	 * @author ...
	 */
	public class TaskPromptItem 
	{
		public var m_ID:int;
		public var m_name:String;			//推荐任务名
		public var m_rewardDesc:String;		//奖励描述
		public var m_curCounts:int;			//当前进行次数
		public var m_countsMax:int;			//该任务每日进行最大次数
		public var m_recommendLevel:int;	//推荐等级(重要性)
		
		public function TaskPromptItem() 
		{
			m_ID = 0;
			m_name = "";
			m_rewardDesc = "";
			m_curCounts = 0;
			m_countsMax = 0;
			m_recommendLevel = 0;
		}
		
		public function parseXml(xml:XML):void
		{
			m_ID = parseInt(xml.@id);
			m_name = xml.@name;
			m_rewardDesc = xml.@rewarddesc;
			m_recommendLevel = parseInt(xml.@level);
		}
	}

}