package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stAddNewWuNvUserCmd extends stWuNvCmd 
	{
		public var m_id:uint;	
		public function stAddNewWuNvUserCmd() 
		{
			super();
			byParam = NOTIFY_ADD_NEW_WUNV_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_id = byte.readUnsignedInt();
			
		}
		
	}

}
/*//获得新舞女信息 s->c
    const BYTE NOTIFY_ADD_NEW_WUNV_USERCMD = 13; 
    struct stAddNewWuNvUserCmd : public stWuNvCmd
    {   
        stAddNewWuNvUserCmd()
        {   
            byParam = NOTIFY_ADD_NEW_WUNV_USERCMD;
            id = 0;
            type = 0;
        }   
        DWORD id;       
    };  */