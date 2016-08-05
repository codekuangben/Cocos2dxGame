package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetLotteryResultUserCmd extends stCorpsCmd
	{
		public var m_rewardtype:uint;
		public var m_cishu:uint;
		public var m_extra:uint;
		
		public function stRetLotteryResultUserCmd() 
		{
			byParam = PARA_RET_LOTTERY_RESULT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_rewardtype = byte.readUnsignedByte();
			m_cishu = byte.readUnsignedByte();
			m_extra = byte.readUnsignedInt();
		}
		
	}

}

/*
//返回军团抽奖结果
    const BYTE PARA_RET_LOTTERY_RESULT_USERCMD = 96;
    struct stRetLotteryResultUserCmd : public stCorpsCmd
    {
        stRetLotteryResultUserCmd()
        {
            byParam = PARA_RET_LOTTERY_RESULT_USERCMD;
            rewardtype = 0;
            cishu = 0;
            extra = 0;
        }
        BYTE rewardtype;    //奖励类型
        BYTE cishu; //抽奖次数
        DWORD extra;
    };
*/