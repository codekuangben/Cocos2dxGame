package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class WuNvReap 
	{
		public var m_id:uint;
		public var m_count:uint;
		public function deserialize(byte:ByteArray):void
		{
			m_id = byte.readUnsignedInt();
			m_count = byte.readUnsignedInt();
		}
		
	}

}
/*struct WuNvReap {
        DWORD id; 
        DWORD count;
    };*/