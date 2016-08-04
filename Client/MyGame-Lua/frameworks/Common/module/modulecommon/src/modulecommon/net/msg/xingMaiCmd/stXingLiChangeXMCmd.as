package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stXingLiChangeXMCmd extends stXingMaiCmd
	{
		public var m_xingli:uint;
		
		public function stXingLiChangeXMCmd() 
		{
			byParam = PARA_XINGLI_CHANGE_XMCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			m_xingli = byte.readUnsignedInt();
		}
	}

}

/*
	//星力变化
    const BYTE PARA_XINGLI_CHANGE_XMCMD = 6;
    struct stXingLiChangeXMCmd : public stXingMaiCmd
    {   
        stXingLiChangeXMCmd()
        {   
            byParam = PARA_XINGLI_CHANGE_XMCMD;
            xingli = 0;
        }   
        DWORD xingli;
    }
*/