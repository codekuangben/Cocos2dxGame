package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stEncourageLefttimesWBCmd extends stWorldBossCmd
	{
		public var m_times:uint;
		
		public function stEncourageLefttimesWBCmd() 
		{
			byParam = PARA_ENCOURAGE_LEFTTIMES_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_times = byte.readUnsignedShort();
		}
	}

}
/*
	//剩余激励次数
	const BYTE PARA_ENCOURAGE_LEFTTIMES_WBCMD = 13;
	struct stEncourageLefttimesWBCmd : public stWorldBossCmd
	{
		stEncourageLefttimesWBCmd()
		{
			byParam = PARA_ENCOURAGE_LEFTTIMES_WBCMD;
			times = 0;
		}
		WORD times;
	};
*/