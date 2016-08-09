package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyCorpsLotteryTimesCmd extends stCorpsCmd
	{
		public var lotterytimes:uint;
		
		public function stNotifyCorpsLotteryTimesCmd() 
		{
			byParam = PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			lotterytimes = byte.readUnsignedByte();
		}
	}

}
/*
//上线通知抽奖次数
    const BYTE PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD = 98;
    struct stNotifyCorpsLotteryTimesCmd : public stCorpsCmd
    {    
        stNotifyCorpsLotteryTimesCmd()
        {    
            byParam = PARA_NOTIFY_CORPS_LOTTERY_TIMES_USERCMD;
            lotterytimes = 0; 
        }    
        BYTE lotterytimes;
    };   
*/