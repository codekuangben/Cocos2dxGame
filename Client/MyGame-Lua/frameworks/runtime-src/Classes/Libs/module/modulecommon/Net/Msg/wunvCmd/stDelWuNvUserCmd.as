package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stDelWuNvUserCmd extends stWuNvCmd 
	{
		public var id:uint;
		public function stDelWuNvUserCmd() 
		{
			super();
			
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			id = byte.readUnsignedInt();
		}
	}

}

//删除神秘舞女信息 s->c
    /*const BYTE NOTIFY_DEL_WUNV_USERCMD = 16;
    struct stDelWuNvUserCmd : public stWuNvCmd
    {
        stDelWuNvUserCmd()
        {
            byParam = NOTIFY_DEL_WUNV_USERCMD;
            id = 0;
        }
        DWORD id;
    };*/