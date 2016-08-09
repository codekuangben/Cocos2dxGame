package modulecommon.net.msg.trialTowerCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stSendOnlineDataCmd extends stTrialTowerCmd 
	{
		public var m_tzTimes:int;
		public var m_bInChallenge:Boolean;
		public var m_historylayer:int;
		public function stSendOnlineDataCmd() 
		{
			byParam = SEND_ONLINE_DATA_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_tzTimes = byte.readUnsignedByte();
			m_bInChallenge = byte.readBoolean();
			m_historylayer = byte.readUnsignedShort();
		}
		
	}

}

//上线发送可挑战次数和是否处于挑战中
    /*const BYTE SEND_ONLINE_DATA_PARA = 12; 
    struct  stSendOnlineDataCmd : public stTrialTowerCmd
    {   
        stSendOnlineDataCmd()
        {   
            byParam = SEND_ONLINE_DATA_PARA;
            tztimes = inchallenge = 0;
        }   
        BYTE tztimes;   //可挑战次数
        BYTE inchallenge;   //是否处于挑战中
		WORD historylayer;
    };*/