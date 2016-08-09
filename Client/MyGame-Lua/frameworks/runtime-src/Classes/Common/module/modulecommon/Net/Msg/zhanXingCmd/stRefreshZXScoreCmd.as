package modulecommon.net.msg.zhanXingCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stRefreshZXScoreCmd extends stZhanXingCmd 
	{
		public var m_score:uint;
		public function stRefreshZXScoreCmd() 
		{
			super();
			byParam = PARA_REFRESH_ZXSCORE_ZXCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_score = byte.readUnsignedInt();
		}
		
	}

}
/*//刷新占星积分
    const BYTE PARA_REFRESH_ZXSCORE_ZXCMD = 14;
    struct stRefreshZXScoreCmd : public stZhanXingCmd
    {
        stRefreshZXScoreCmd()
        {
            byParam = PARA_REFRESH_ZXSCORE_ZXCMD;
            score = 0;
        }
        DWORD score;
    };
*/