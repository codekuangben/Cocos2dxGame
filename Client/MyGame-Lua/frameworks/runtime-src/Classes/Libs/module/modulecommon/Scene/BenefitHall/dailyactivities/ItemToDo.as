package modulecommon.scene.benefithall.dailyactivities 
{
	/**
	 * ...
	 * @author ...
	 * 活跃任务项
	 */
	public class ItemToDo 
	{
		public var m_id:int;		//活跃任务编号
		public var m_value:uint;	//活跃度值
		public var m_maxCounts:uint;//任务次数上限
		public var m_curCounts:uint;//已完成次数
		public var m_name:String;	//活跃任务名称
		public var m_vecTimes:Vector.<TimeInterval>;	//活动时间(=null表示全天)
		public var m_tips:String;	//tips描述
		public var m_reward:String;	//奖励
		
		public function ItemToDo() 
		{
			m_name = "";
			m_tips = "";
			m_reward = "";
		}
		
		public function parseXml(xml:XML):void
		{
			m_id = parseInt(xml.@id);
			m_value = parseInt(xml.@fenshu);
			m_maxCounts = parseInt(xml.@num);
			m_name = xml.@name;
			
			parseXmlOfActTimes(xml.@time);
			
			m_tips = xml.@tip;
			m_reward = xml.@reward;
		}
		
		
		private function parseXmlOfActTimes(str:String):void
		{
			if ((null == str) || ("" == str))
			{
				return;
			}
			
			m_vecTimes = new Vector.<TimeInterval>();
			
			var itemtime:TimeInterval;
			var subAr:Array;
			var beginTimeAr:Array;
			var endTimeAr:Array;
			var ar:Array = str.split(";");
			
			for (var i:int = 0; i < ar.length; i++)
			{
				itemtime = new TimeInterval();
				subAr = (ar[i] as String).split("-");
				if (2 == subAr.length)
				{
					beginTimeAr = (subAr[0] as String).split(":");
					if (2 == beginTimeAr.length)
					{
						itemtime.setBeginTime(parseInt(beginTimeAr[0]), parseInt(beginTimeAr[1]));
					}
					
					endTimeAr = (subAr[1] as String).split(":");
					if (2 == endTimeAr.length)
					{
						itemtime.setEndTime(parseInt(endTimeAr[0]), parseInt(endTimeAr[1]));
					}
					
					m_vecTimes.push(itemtime);
				}
			}
		}
		
		//是否已完成
		public function get bCompleted():Boolean
		{
			return (m_curCounts >= m_maxCounts);
		}
	}

}