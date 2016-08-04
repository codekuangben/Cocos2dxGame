package modulecommon.net.msg.giftCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqActLiBaoContentCmd extends stGiftCmd
	{
		
		public function stReqActLiBaoContentCmd() 
		{
			byParam = PARA_REQ_ACTLIBAO_CONTENT_CMD;
		}
		
	}

}
/*
//请求活动礼包内容
    const BYTE PARA_REQ_ACTLIBAO_CONTENT_CMD = 19; 
    struct stReqActLiBaoContentCmd : public stGiftCmd
    {   
        stReqActLiBaoContentCmd()
        {   
            byParam = PARA_REQ_ACTLIBAO_CONTENT_CMD;
        }   
    };
*/