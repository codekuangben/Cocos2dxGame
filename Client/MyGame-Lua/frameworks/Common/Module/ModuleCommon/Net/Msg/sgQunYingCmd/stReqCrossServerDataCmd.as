package modulecommon.net.msg.sgQunYingCmd 
{
	/**
	 * ...
	 * @author 
	 */
	public class stReqCrossServerDataCmd extends stSGQunYingCmd 
	{
		
		public function stReqCrossServerDataCmd() 
		{
			super();
			byParam = PARA_REQ_CROSS_SERVER_DATA_CMD;
		}
		
	}

}

//请求跨服数据
	/*const BYTE PARA_REQ_CROSS_SERVER_DATA_CMD = 2;
	struct stReqCrossServerDataCmd : public stSGQunYingCmd
	{
		stReqCrossServerDataCmd()
		{
			byParam = PARA_REQ_CROSS_SERVER_DATA_CMD;
		}
	};*/