package modulecommon.net.msg.copyUserCmd 
{	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stReqLeaveCopyUserCmd extends stCopyUserCmd 
	{
		public function stReqLeaveCopyUserCmd() 
		{
			byParam = REQ_LEAVE_COPY_USERCMD;
		}
	}
}
//退出副本
/*const BYTE  REQ_LEAVE_COPY_USERCMD = 24;
struct  stReqLeaveCopyUserCmd: public stCopyUserCmd
{
	stReqLeaveCopyUserCmd()
	{
		byParam = REQ_LEAVE_COPY_USERCMD;
	}
};*/