package game.netmsg.copycmd 
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 * 零点数据刷新(服务器时间此时00:00:00点)
	 */
	public class st0ClockUserCmd extends stCopyUserCmd
	{
		
		public function st0ClockUserCmd() 
		{
			byParam = st0_CLOCK_USERCMD;
		}
		
	}

}
/*
 const BYTE st0_CLOCK_USERCMD = 60; 
    struct  st0ClockUserCmd: public stCopyUserCmd
    {   
        st0ClockUserCmd()
        {   
            byParam = st0_CLOCK_USERCMD;
        }   
    };  
*/