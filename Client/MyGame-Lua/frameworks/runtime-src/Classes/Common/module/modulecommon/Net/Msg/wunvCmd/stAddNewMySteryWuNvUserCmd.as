package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stAddNewMySteryWuNvUserCmd extends stWuNvCmd 
	{
		public var id:uint;
		public var num:uint;
		public function stAddNewMySteryWuNvUserCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
			num = byte.readUnsignedByte();
		}
		
	}

}

//获得新神秘舞女信息 s->c
    /*const BYTE NOTIFY_ADD_NEW_MYSTERY_WUNV_USERCMD = 15;
    struct stAddNewMySteryWuNvUserCmd : public stWuNvCmd
    {
        stAddNewMySteryWuNvUserCmd()
        {
            byParam = NOTIFY_ADD_NEW_MYSTERY_WUNV_USERCMD;
            id = 0;
            num = 0;
        }
        DWORD id;
        BYTE num;
    };*/