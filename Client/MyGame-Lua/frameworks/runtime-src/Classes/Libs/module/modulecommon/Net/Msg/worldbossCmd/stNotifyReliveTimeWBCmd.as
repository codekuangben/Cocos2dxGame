package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stNotifyReliveTimeWBCmd extends stWorldBossCmd
	{
		public var m_sec:uint;
		
		public function stNotifyReliveTimeWBCmd() 
		{
			byParam = PARA_NOTIFY_RELIVE_TIME_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_sec = byte.readUnsignedShort();
		}
	}

}
/*
	//通知复活等待时间
	const BYTE PARA_NOTIFY_RELIVE_TIME_WBCMD = 7;
	struct stNotifyReliveTimeWBCmd : public stWorldBossCmd
	{
		stNotifyReliveTimeWBCmd()
		{
			byParam = PARA_NOTIFY_RELIVE_TIME_WBCMD;
			sec = 0;
		}
		WORD sec;
	};
*/