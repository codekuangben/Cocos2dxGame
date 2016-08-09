package modulecommon.net.msg.copyUserCmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class stReqBoxTipContextUserCmd extends stCopyUserCmd
	{
		public function stReqBoxTipContextUserCmd()
		{
			byParam = REQ_BOX_TIP_CONTEXT_USERCMD;
		}
	}
}


//const BYTE REQ_BOX_TIP_CONTEXT_USERCMD = 22; 
//struct  stReqBoxTipContextUserCmd: public stCopyUserCmd
//{   
//	stReqBoxTipContextUserCmd()
//	{   
//		byParam = REQ_BOX_TIP_CONTEXT_USERCMD;
//	}   
//};