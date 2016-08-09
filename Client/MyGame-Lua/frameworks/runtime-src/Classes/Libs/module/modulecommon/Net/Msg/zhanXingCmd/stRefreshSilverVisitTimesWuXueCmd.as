package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	/**
	 * 刷新银币探访次数
	 * @author 
	 */
	public class stRefreshSilverVisitTimesWuXueCmd extends stZhanXingCmd 
	{
		/**
		 * 剩余银币探访次数
		 */
		public var m_silvervisittimes:uint;
		public function stRefreshSilverVisitTimesWuXueCmd() 
		{
			super();
			byParam = PARA_REFRESH_SILVER_VISIT_TIMES_WUXUE_CMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_silvervisittimes = byte.readUnsignedShort();
		}
		
	}

}/*//刷新银币探访次数
    const BYTE PARA_REFRESH_SILVER_VISIT_TIMES_WUXUE_CMD = 17;
    struct stRefreshSilverVisitTimesWuXueCmd : public stZhanXingCmd
    {
        stRefreshSilverVisitTimesWuXueCmd()
        {
            byParam = PARA_REFRESH_SILVER_VISIT_TIMES_WUXUE_CMD;
            silvervisittimes = 0;
        }
        WORD silvervisittimes;
    };

*/