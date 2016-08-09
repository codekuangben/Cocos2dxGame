package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author helloworld
	 */
	public class stGuanZhiJingJiPkCountUserCmd extends stGuanZhiJingJiCmd
	{
		private var m_count:int;
		public function stGuanZhiJingJiPkCountUserCmd() 
		{
			byParam = GUAN_ZHI_JING_JI_PK_COUNT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_count = byte.readUnsignedByte();
		}
		
		public function get count():int
		{
			return m_count;
		}
	}

}

/*
//本日已经挑战过次数
    const BYTE GUAN_ZHI_JING_JI_PK_COUNT_USERCMD = 8;
    struct stGuanZhiJingJiPkCountUserCmd : public stGuanZhiJingJiCmd
    {   
        stGuanZhiJingJiPkCountUserCmd()
        {   
            byParam = GUAN_ZHI_JING_JI_PK_COUNT_USERCMD;
            count = 0;
        }   
        BYTE count; 
    };  
*/