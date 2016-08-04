package game.ui.uiwuxueexchange.msg 
{
	import modulecommon.net.msg.zhanXingCmd.stZhanXingCmd;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stWuXueExchangeCmd extends stZhanXingCmd 
	{
		public var m_wxid:uint;
		public function stWuXueExchangeCmd() 
		{
			super();
			byParam = stZhanXingCmd.PARA_WUXUE_EXCHANGE_ZXCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(m_wxid);
		}
		
	}

}
/*积分兑换武学
    const BYTE PARA_WUXUE_EXCHANGE_ZXCMD = 15;
    struct stWuXueExchangeCmd : public stZhanXingCmd
    {
        stWuXueExchangeCmd()
        {
            byParam = PARA_WUXUE_EXCHANGE_ZXCMD;
            wxid = 0;
        }
        DWORD wxid;
    };
*/