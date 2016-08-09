package modulecommon.net.msg.eliteBarrierCmd 
{
	import flash.utils.ByteArray;
	/**
	 * 通知BOSS信息
	 * @author 
	 */
	public class stNotifyEliteBossInfoCmd extends stEliteBarrierCmd 
	{
		/**
		 * boss头上显示第几波boss
		 */
		public var m_pkbatch:uint;
		/**
		 * boss头上显示物品id
		 */
		public var m_objid:uint;
		/**
		 * boss头上物品数量
		 */
		public var m_num:uint;
		/**
		 * boss id
		 */
		public var m_bossid:uint;
		public function stNotifyEliteBossInfoCmd() 
		{
			super();
			byParam = PARA_NOTIFY_ELITE_BOSS_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_bossid = byte.readUnsignedInt();
			m_pkbatch = byte.readUnsignedShort();
			m_objid = byte.readUnsignedInt();
			m_num = byte.readUnsignedShort();
		}
	}

}/*//通知BOSS信息
    const BYTE PARA_NOTIFY_ELITE_BOSS_INFO_CMD = 16; 
    struct stNotifyEliteBossInfoCmd : public stEliteBarrierCmd
    {   
        stNotifyEliteBossInfoCmd()
        {   
            byParam = PARA_NOTIFY_ELITE_BOSS_INFO_CMD;
            pkbatch = 0;
            objid = 0;
            num = 0;
        }   
		DWORD bossid;
        WORD pkbatch;   //波次
        DWORD objid;
        WORD num;
    };*/