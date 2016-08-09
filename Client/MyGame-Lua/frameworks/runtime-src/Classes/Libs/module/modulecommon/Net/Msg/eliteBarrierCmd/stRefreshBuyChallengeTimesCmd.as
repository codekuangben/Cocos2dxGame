package modulecommon.net.msg.eliteBarrierCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshBuyChallengeTimesCmd extends stEliteBarrierCmd 
	{
		public var m_buytimes:int;
		public function stRefreshBuyChallengeTimesCmd() 
		{
			super();
			
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_buytimes = byte.readUnsignedShort();
		}
		
	}

}

//刷新已经购买的次数
    /*const BYTE PARA_REFRESH_BUY_CHALLENGE_TIMES_CMD = 14; 
    struct stRefreshBuyChallengeTimesCmd : public stEliteBarrierCmd
    {   
        stRefreshBuyChallengeTimesCmd()
        {   
            byParam = PARA_REFRESH_BUY_CHALLENGE_TIMES_CMD;
        }   
        WORD buytimes;
    }; */