package modulecommon.net.msg.guanZhiJingJiCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqGetGuanzhiCmd extends stGuanZhiJingJiCmd
	{
		
		public function stReqGetGuanzhiCmd() 
		{
			byParam = REQ_GET_GUANZHI_USERCMD;
		}
		
	}

}
/*
//请求领取俸禄
    const BYTE REQ_GET_GUANZHI_USERCMD = 17; 
    struct stReqGetGuanzhiCmd : public stGuanZhiJingJiCmd
    {   
        stReqGetGuanzhiCmd()
        {   
            byParam = REQ_GET_GUANZHI_USERCMD;
        }   
    };  
*/