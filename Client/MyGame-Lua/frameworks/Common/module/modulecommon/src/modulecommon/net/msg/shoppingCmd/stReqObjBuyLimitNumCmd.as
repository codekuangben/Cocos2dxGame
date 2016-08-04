package modulecommon.net.msg.shoppingCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqObjBuyLimitNumCmd extends stShoppingCmd 
	{
		
		public function stReqObjBuyLimitNumCmd() 
		{
			byParam = PARA_REQ_OBJ_BUYLIMITNUM_CMD;
			
		}
		
	}

}

//请求已购买限购物品的数量
    /*const BYTE PARA_REQ_OBJ_BUYLIMITNUM_CMD = 5;
    struct stReqObjBuyLimitNumCmd : public stShoppingCmd
    {   
        stReqObjBuyLimitNumCmd()
        {   
            byParam = PARA_REQ_OBJ_BUYLIMITNUM_CMD;
        }   
    };  */
