package modulecommon.net.msg.copyUserCmd 
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class reqUserProfitInCopyUserCmd extends stCopyUserCmd
	{
		
		public function reqUserProfitInCopyUserCmd() 
		{
			byParam = stCopyUserCmd.REQ_USE_PROFIT_IN_COPY_USERCMD;
		}
		
	}

}
/*
//请求本副本使用收益 c->s
    const BYTE REQ_USE_PROFIT_IN_COPY_USERCMD = 45; 
    struct reqUserProfitInCopyUserCmd : public stCopyUserCmd
    {   
        reqUserProfitInCopyUserCmd()
        {   
            byParam = REQ_USE_PROFIT_IN_COPY_USERCMD;
        }   
    };  
*/