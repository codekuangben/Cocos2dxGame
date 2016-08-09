package modulecommon.net.msg.shoppingCmd 
{
	import modulecommon.net.msg.shoppingCmd.stShoppingCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class stReqShoppingMallDataCmd extends stShoppingCmd 
	{
		
		public function stReqShoppingMallDataCmd() 
		{
			byParam = PARA_REQ_SHOPPINGMALL_DATA_CMD;
		}
		
	}

}

//请求商城数据
	/*const BYTE PARA_REQ_SHOPPINGMALL_DATA_CMD = 1;
	struct stReqShoppingMallDataCmd : public stShoppingCmd
	{
		stReqShoppingMallDataCmd()
		{
			byParam = PARA_REQ_SHOPPINGMALL_DATA_CMD;
		}
	};*/