package modulecommon.net.msg.shoppingCmd 
{
	/**
	 * ...
	 * @author ...
	 */
	public class stReqCorpsMallObjListCmd extends stShoppingCmd 
	{
		
		public function stReqCorpsMallObjListCmd() 
		{
			super();
			byParam = PARA_REQ_CORPSMALL_OBJLIST_CMD;
		}
		
	}

}

//请求军团商城物品
    /*const BYTE PARA_REQ_CORPSMALL_OBJLIST_CMD = 10; 
    struct stReqCorpsMallObjListCmd : public stShoppingCmd
    {   
        stReqCorpsMallObjListCmd()
        {   
            byParam = PARA_REQ_CORPSMALL_OBJLIST_CMD;
        }   
    };*/