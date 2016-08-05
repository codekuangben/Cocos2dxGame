package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stGuanZhiJingJiPkDaoJiShiUserCmd extends stGuanZhiJingJiCmd
	{
		private var m_time:uint;
		public function stGuanZhiJingJiPkDaoJiShiUserCmd() 
		{
			byParam = GUAN_ZHI_JING_JI_PK_DAO_JI_SHI_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_time = byte.readUnsignedShort();
		}
		
		public function get time():uint
		{
			return m_time;
		}
	}

}

/*
    //挑战倒计时
    const BYTE GUAN_ZHI_JING_JI_PK_DAO_JI_SHI_USERCMD = 9;
    struct stGuanZhiJingJiPkDaoJiShiUserCmd : public stGuanZhiJingJiCmd
    {   
        stGuanZhiJingJiPkDaoJiShiUserCmd()
        {   
            byParam = GUAN_ZHI_JING_JI_PK_DAO_JI_SHI_USERCMD;
            time = 0;
        }   
        WORD time; 
    }; 
*/