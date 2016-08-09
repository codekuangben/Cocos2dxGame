package modulecommon.net.msg.guanZhiJingJiCmd 
{	
	/**
	 * ...
	 * @author 
	 */
	public class stReqOpenGuanZhiJingJiUserCmd extends stGuanZhiJingJiCmd 
	{
		
		public function stReqOpenGuanZhiJingJiUserCmd() 
		{
			byParam = REQ_OPEN_GUAN_ZHI_JING_JI_USERCMD;
		}
		
	}

}


//请求打开大界面
	/*const BYTE REQ_OPEN_GUAN_ZHI_JING_JI_USERCMD = 1;
	struct stReqOpenGuanZhiJingJiUserCmd : public stGuanZhiJingJiCmd
	{
		stReqOpenGuanZhiJingJiUserCmd()
		{
			byParam = REQ_OPEN_GUAN_ZHI_JING_JI_USERCMD;
		}
	};*/