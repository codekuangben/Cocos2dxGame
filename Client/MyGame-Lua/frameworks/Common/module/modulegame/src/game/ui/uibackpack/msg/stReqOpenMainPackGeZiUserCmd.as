package game.ui.uibackpack.msg 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.propertyUserCmd.stPropertyUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class stReqOpenMainPackGeZiUserCmd extends stPropertyUserCmd 
	{
		public var m_num:int;
		public function stReqOpenMainPackGeZiUserCmd() 
		{
			byParam = REQ_OPEN_MAINPACK_GEZI_USERCMD;
		}
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeByte(m_num);
		}
		
	}

}

//请求开启格子
    /*struct BYTE REQ_OPEN_MAINPACK_GEZI_USERCMD = 16;
    struct stReqOpenMainPackGeZiUserCmd : public stPropertyUserCmd
    {
        stReqOpenMainPackGeZiUserCmd()
        {
            byParam = REQ_OPEN_MAINPACK_GEZI_USERCMD;
        }
        BYTE num;
    };
*/