package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stLimitBigSendItem 
	{
		public var m_actid:uint;
		public var m_progress:uint;
		public var m_rewardtimes:uint;
		public function deserialize(byte:ByteArray):void
		{
			m_actid = byte.readUnsignedShort();
			m_progress = byte.readUnsignedInt();
			m_rewardtimes = byte.readUnsignedInt();
		}
	}

}
/*//限时大放送条目
    struct stLimitBigSendItem
    {   
        WORD actid; //条目id
        DWORD progress; //进度
        DWORD rewardtimes;  //已领次数
        stLimitBigSendItem()
        {   
            actid = 0;  
            progress = rewardtimes = 0;
        }   
    }; */