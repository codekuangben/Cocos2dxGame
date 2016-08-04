package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyLimitBigSendActStateCmd extends stActivityCmd 
	{
		public var m_state:uint;
		public var m_starttime:Number;
		public var m_endtime:Number;
		public var m_delay:Number;
		public function stNotifyLimitBigSendActStateCmd() 
		{
			super();
			byParam = PARA_NOTIFY_LIMIT_BIG_SEND_ACT_STATE_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_state = byte.readUnsignedByte();
			m_starttime = byte.readUnsignedInt();
			m_endtime = byte.readUnsignedInt();
			m_delay = byte.readUnsignedInt();
		}
		
	}

}
/*    //通知限时大放送活动状态
    const BYTE PARA_NOTIFY_LIMIT_BIG_SEND_ACT_STATE_CMD = 9;
    struct stNotifyLimitBigSendActStateCmd : public stActivityCmd
    {
        stNotifyLimitBigSendActStateCmd()
        {
            byParam = PARA_NOTIFY_LIMIT_BIG_SEND_ACT_STATE_CMD;
            state = 0;
             starttime = endtime = delay = 0;
        }
        BYTE state;
        DWORD starttime;
        DWORD endtime;
        DWORD delay;

    };*/