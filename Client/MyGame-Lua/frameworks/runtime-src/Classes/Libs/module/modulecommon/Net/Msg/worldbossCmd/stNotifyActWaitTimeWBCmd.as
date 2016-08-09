package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyActWaitTimeWBCmd extends stWorldBossCmd
	{
		public var m_waittime:uint;
		
		public function stNotifyActWaitTimeWBCmd() 
		{
			byParam = PARA_NOTIFY_ACT_WAITTIME_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_waittime = byte.readUnsignedInt();
		}
	}
	
}
/*
	//通知活动等待时间
	const BYTE PARA_NOTIFY_ACT_WAITTIME_WBCMD = 2;
	struct stNotifyActWaitTimeWBCmd : public stWorldBossCmd
	{
		stNotifyActStateWBCmd()
		{
			byParam = PARA_NOTIFY_ACT_WAITTIME_WBCMD;
			waittime = 0;
		}
		DWORD waittime;	//以秒为单位
	};
*/