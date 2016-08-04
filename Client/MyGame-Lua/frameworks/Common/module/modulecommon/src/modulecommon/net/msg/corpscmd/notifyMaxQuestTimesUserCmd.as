package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class notifyMaxQuestTimesUserCmd extends stCorpsCmd
	{
		public var num:uint;
		public var lotterynum:uint;
		
		public function notifyMaxQuestTimesUserCmd() 
		{
			byParam = NOTIFY_MAX_QUEST_TIMES_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			num = byte.readUnsignedByte();
			lotterynum = byte.readUnsignedByte();
		}
	}

}

/*
//更新每日可接任务最大次数
    const BYTE NOTIFY_MAX_QUEST_TIMES_USERCMD = 58; 
    struct notifyMaxQuestTimesUserCmd : public stCorpsCmd
    {   
        notifyMaxQuestTimesUserCmd()
        {   
            byParam = NOTIFY_MAX_QUEST_TIMES_USERCMD;
            num = 0;
			lotterynum = 0;
        }   
        BYTE num; //当前军团等级可接最大任务次数
		BYTE lotterynum;    //当前军团等级最大可抽奖次数
    };  
*/