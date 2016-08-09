package game.netmsg.stWuNvCmd 
{
	import modulecommon.net.msg.wunvCmd.stWuNvCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stReqOpenWuNvUIUserCmd extends stWuNvCmd 
	{
		
		public function stReqOpenWuNvUIUserCmd() 
		{
			super();
			byParam = REQ_OPEN_WU_NV_UI_USERCMD;
		}
		
	}

}
/*//打开舞女活动按钮 c->s
	const BYTE REQ_OPEN_WU_NV_UI_USERCMD = 2;
	struct stReqOpenWuNvUIUserCmd : public stWuNvCmd
	{
		stReqOpenWuNvUIUserCmd()
		{
			byParam = REQ_OPEN_WU_NV_UI_USERCMD;
		}
	};*/