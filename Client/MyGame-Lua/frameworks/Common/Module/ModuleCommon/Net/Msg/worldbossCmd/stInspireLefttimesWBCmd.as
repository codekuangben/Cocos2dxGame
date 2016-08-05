package modulecommon.net.msg.worldbossCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stInspireLefttimesWBCmd extends stWorldBossCmd
	{
		public var m_times:uint;
		
		public function stInspireLefttimesWBCmd() 
		{
			byParam = PARA_INSPIRE_LEFTTIMES_WBCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_times = byte.readUnsignedShort();
		}
	}

}
/*
	//鼓舞剩余次数
	const BYTE PARA_INSPIRE_LEFTTIMES_WBCMD = 11;
	struct stInspireLefttimesWBCmd : public stWorldBossCmd
	{
		stInspireLefttimesWBCmd()
		{
			byParam = PARA_INSPIRE_LEFTTIMES_WBCMD;
			times = 0;
		}
		WORD times;
	};
*/