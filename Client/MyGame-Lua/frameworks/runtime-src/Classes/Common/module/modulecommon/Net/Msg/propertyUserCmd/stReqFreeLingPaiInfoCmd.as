package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqFreeLingPaiInfoCmd extends stPropertyUserCmd
	{
		
		public function stReqFreeLingPaiInfoCmd() 
		{
			byParam = PARA_REQ_FREE_LINGPAI_INFO_USERCMD;
		}
		
	}

}

/*
 * //请求令牌信息
    const BYTE PARA_REQ_FREE_LINGPAI_INFO_USERCMD = 39;
    struct stReqFreeLingPaiInfoCmd : public stPropertyUserCmd
    {
        stReqFreeLingPaiInfoCmd()
        {
            byParam = PARA_REQ_FREE_LINGPAI_INFO_USERCMD;
        }   
    };  
*/