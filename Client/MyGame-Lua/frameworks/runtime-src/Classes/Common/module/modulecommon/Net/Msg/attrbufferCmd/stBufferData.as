package modulecommon.net.msg.attrbufferCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 * 人物属性加成Buffer数据
	 */
	public class stBufferData 
	{
		public var m_bufferid:uint;
		public var m_lefttime:uint;
		public var m_coef:uint;		//加成系数
		public var m_extra:uint;	//道具id(当前)
		
		public function stBufferData() 
		{
			m_bufferid = 0;
			m_lefttime = 0;
			m_coef = 0;
			m_extra = 0;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			m_bufferid = byte.readUnsignedShort();
			m_lefttime = byte.readUnsignedInt();
			m_coef = byte.readUnsignedShort();
			m_extra = byte.readUnsignedInt();
		}
	}

}

/*
//buffer数据
    struct stBufferData
    {    
        WORD bufferid;
        DWORD lefttime;
        WORD coef;
        DWORD extra;
        stBufferData()
        {    
            bufferid = 0; 
            lefttime = extra = 0; 
        }    
        stBufferData(const WORD _bufferid,const DWORD _lefttime)
            : bufferid(_bufferid),lefttime(_lefttime)
        {    
            extra = 0; 
        }    
    };   
*/