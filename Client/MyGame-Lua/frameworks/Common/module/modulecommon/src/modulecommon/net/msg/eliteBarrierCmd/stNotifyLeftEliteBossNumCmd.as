package modulecommon.net.msg.eliteBarrierCmd 
{
	import flash.utils.ByteArray;
	/**
	 * 通知精英boss剩余个数 用于screenbtn上显示
	 * @author 
	 */
	public class stNotifyLeftEliteBossNumCmd extends stEliteBarrierCmd 
	{
		/**
		 * 剩余boss数量
		 */
		public var m_leftbossnum:uint;
		public function stNotifyLeftEliteBossNumCmd() 
		{
			super();
			byParam = PARA_ELITE_BOSS_ONLINE_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_leftbossnum = byte.readUnsignedShort();
		}
	}

}/*
const BYTE PARA_ELITE_BOSS_ONLINE_INFO_CMD = 17; 
    struct stEliteBossOnlineInfoCmd : public stEliteBarrierCmd
    {   
        stEliteBossOnlineInfoCmd()
        {   
            byParam = PARA_ELITE_BOSS_ONLINE_INFO_CMD;
            leftbossnum = 0;
        }   
        WORD leftbossnum;
    };  
*/