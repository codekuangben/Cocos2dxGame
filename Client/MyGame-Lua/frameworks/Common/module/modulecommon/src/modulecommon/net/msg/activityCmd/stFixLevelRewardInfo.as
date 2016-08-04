package modulecommon.net.msg.activityCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stFixLevelRewardInfo 
	{
		public var m_day:int;
		public var m_level:int;
		public var m_rewardflag:int;
		public function deserialize(byte:ByteArray):void
		{
			m_day = byte.readUnsignedShort();
			m_level = byte.readUnsignedInt();
			m_rewardflag = byte.readUnsignedInt();
		}
		
	}

}
//固定等级奖励信息
    /*struct stFixLevelRewardInfo
    {   
        WORD day;   //第几日排行榜;
        DWORD level;    //冲榜到达的最高等级
        DWORD rewardflag;   //奖励
    };*/