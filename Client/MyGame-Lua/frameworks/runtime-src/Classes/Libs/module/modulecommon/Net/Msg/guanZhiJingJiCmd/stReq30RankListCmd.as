package modulecommon.net.msg.guanZhiJingJiCmd 
{
	import modulecommon.net.msg.guanZhiJingJiCmd.stGuanZhiJingJiCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stReq30RankListCmd extends stGuanZhiJingJiCmd
	{
		
		public function stReq30RankListCmd() 
		{
			byParam = REQ_30_RANK_LIST_USERCMD;
		}
		
	}

}

/*
//请求30名积分榜
    const BYTE REQ_30_RANK_LIST_USERCMD = 10; 
    struct stReq30RankListCmd : public stGuanZhiJingJiCmd
    {   
        stReq30RankListCmd()
        {   
            byParam = REQ_30_RANK_LIST_USERCMD;
        }   
    };  

*/