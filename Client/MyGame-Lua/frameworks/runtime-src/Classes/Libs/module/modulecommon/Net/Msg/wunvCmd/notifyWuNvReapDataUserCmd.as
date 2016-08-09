package modulecommon.net.msg.wunvCmd 
{
	import flash.utils.ByteArray
	/**
	 * ...
	 * @author ...
	 */
	public class notifyWuNvReapDataUserCmd extends stWuNvCmd 
	{
		public var m_size:uint;
		public var m_wuNvReap:Vector.<WuNvReap>;
		public function notifyWuNvReapDataUserCmd() 
		{
			super();
			byParam = NOTIFY_WUNV_REAP_DATA_USERCMD;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			m_wuNvReap = new Vector.<WuNvReap>();
			var i:int
			var m_size:uint = byte.readUnsignedByte();
			var data:WuNvReap;
			for (i = 0; i < m_size; i++ )
			{
				data = new WuNvReap();
				data.deserialize(byte);
				m_wuNvReap.push(data);
			}
		}
	}

}
/*//舞女收获信息 s->c
    const BYTE NOTIFY_WUNV_REAP_DATA_USERCMD = 14; 
    struct notifyWuNvReapDataUserCmd : public stWuNvCmd
    {   
        notifyWuNvReapDataUserCmd()
        {   
            byParam = NOTIFY_WUNV_REAP_DATA_USERCMD;
        }   
        BYTE size;
        WuNvReap data[0];
        WORD getSize( void ) const { return sizeof(*this) + sizeof(WuNvReap)*size; }
    };  
*/