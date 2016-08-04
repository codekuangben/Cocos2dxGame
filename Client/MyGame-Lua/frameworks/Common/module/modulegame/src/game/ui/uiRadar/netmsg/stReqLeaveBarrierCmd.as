package  game.ui.uiRadar.netmsg
{
	import modulecommon.net.msg.eliteBarrierCmd.stEliteBarrierCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stReqLeaveBarrierCmd extends stEliteBarrierCmd
	{
		
		public function stReqLeaveBarrierCmd() 
		{
			byParam = PARA_REQ_LEAVE_BARRIER_CMD;
		}
		
	}

}

/*
//退出关卡
	const BYTE PARA_REQ_LEAVE_BARRIER_CMD = 8;
    struct stReqLeaveBarrierCmd : public stEliteBarrierCmd
    {   
        stReqLeaveBarrierCmd()
        {   
            byParam = PARA_REQ_LEAVE_BARRIER_CMD;
        }   
    };
*/