package game.netmsg.copycmd
{
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stNotifyCopyOverUserCmd extends stCopyUserCmd
	{
		public function stNotifyCopyOverUserCmd() 
		{
			super();
			byParam = NOTIFY_COPY_OVER_USERCMD;
		}
	}
}

//通知客户端副本结束
//const BYTE  NOTIFY_COPY_OVER_USERCMD = 8;
//struct  stNotifyCopyOverUserCmd: public stCopyUserCmd
//{   
    //stNotifyCopyOverUserCmd()
    //{   
        //byParam = NOTIFY_COPY_OVER_USERCMD;
    //}   
//};