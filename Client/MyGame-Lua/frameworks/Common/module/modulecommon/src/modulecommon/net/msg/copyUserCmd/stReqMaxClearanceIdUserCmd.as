package modulecommon.net.msg.copyUserCmd
{	
	import flash.utils.ByteArray;
	public class stReqMaxClearanceIdUserCmd extends stCopyUserCmd
	{
		public function stReqMaxClearanceIdUserCmd()
		{
			byParam = REQ_MAX_CLEARANCE_ID_USERCMD;
		}
	}
}

//请求最大通关关卡id
/*const BYTE  REQ_MAX_CLEARANCE_ID_USERCMD = 9;
struct  stReqMaxClearanceIdUserCmd: public stCopyUserCmd
{   
	stReqMaxClearanceIdUserCmd()
	{   
		byParam = REQ_MAX_CLEARANCE_ID_USERCMD;
	}   
}; */ 