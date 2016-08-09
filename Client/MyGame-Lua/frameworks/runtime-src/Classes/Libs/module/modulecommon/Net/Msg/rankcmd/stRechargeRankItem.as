package modulecommon.net.msg.rankcmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stRechargeRankItem 
	{
		public var m_index:uint;
		public var m_name:String;
		public var m_yuanbao:uint;
		public function deserialize(byte:ByteArray):void 
		{
			m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_yuanbao = byte.readUnsignedInt();
		}
		
	}

}
/*struct stRechargeRankItem
    {
        char name[MAX_NAMESIZE];
        DWORD yuanbao;
        stRechargeRankItem()
        {
            bzero(name,sizeof(name));
            yuanbao = 0;
        }
    };*/