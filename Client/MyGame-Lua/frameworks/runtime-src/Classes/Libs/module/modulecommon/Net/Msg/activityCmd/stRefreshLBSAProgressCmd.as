package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshLBSAProgressCmd extends stActivityCmd 
	{
		public var m_actid:uint;
		public var m_progress:uint;
		public function stRefreshLBSAProgressCmd() 
		{
			super();
			byParam = PARA_REFRESH_LBSA_PROGRESS_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_actid = byte.readUnsignedShort();
			m_progress = byte.readUnsignedInt();
		}
		
	}

}
/*	 //刷新大放送活动进度
    const BYTE PARA_REFRESH_LBSA_PROGRESS_CMD = 10;
    struct stRefreshLBSAProgressCmd : public stActivityCmd
    {
        stRefreshLBSAProgressCmd()
        {
            byParam = PARA_REFRESH_LBSA_PROGRESS_CMD;
            actid = progress = 0;
        }
        WORD actid;
        DWORD progress;
    };*/