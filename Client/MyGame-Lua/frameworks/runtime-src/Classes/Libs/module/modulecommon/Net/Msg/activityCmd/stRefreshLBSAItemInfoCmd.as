package modulecommon.net.msg.activityCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshLBSAItemInfoCmd extends stActivityCmd 
	{
		public var m_data:stLimitBigSendItem;
		public function stRefreshLBSAItemInfoCmd() 
		{
			super();
			byParam = PARA_REFRESH_LBSA_ITEM_INFO_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_data = new stLimitBigSendItem();
			m_data.deserialize(byte);
		}
	}

}
/*//刷新大放送活动条目信息
    const BYTE PARA_REFRESH_LBSA_ITEM_INFO_CMD = 12;
    struct stRefreshLBSAItemInfoCmd : public stActivityCmd
    {
        stRefreshLBSAItemInfoCmd()
        {
            byParam = PARA_REFRESH_LBSA_ITEM_INFO_CMD;
        }
        stLimitBigSendItem data;
    };*/