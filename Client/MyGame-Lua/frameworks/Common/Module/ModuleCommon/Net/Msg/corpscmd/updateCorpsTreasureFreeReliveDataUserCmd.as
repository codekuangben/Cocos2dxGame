package modulecommon.net.msg.corpscmd 
{
	import flash.utils.ByteArray;
	/**
	 * 军团夺宝通知剩余免费复活次数
	 * @author 
	 */
	public class updateCorpsTreasureFreeReliveDataUserCmd extends stCorpsCmd 
	{
		/**
		 * 剩余免费复活次数
		 */
		public var m_lastFreeReliveTime:uint;
		public function updateCorpsTreasureFreeReliveDataUserCmd() 
		{
			super();
			byParam = UPDATE_CORPS_TREASURE_FREE_RELIVE_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_lastFreeReliveTime = byte.readUnsignedByte();
		}
		
	}

}/*const BYTE UPDATE_CORPS_TREASURE_FREE_RELIVE_USERCMD = 114; 
    struct updateCorpsTreasureFreeReliveDataUserCmd : public stCorpsCmd
    {    
        updateCorpsTreasureFreeReliveDataUserCmd()
        {    
            byParam = UPDATE_CORPS_TREASURE_FREE_RELIVE_USERCMD;
            lastFreeReliveTime= 0;
        }    
        BYTE lastFreeReliveTime; //剩余免费复活次数
    };*/