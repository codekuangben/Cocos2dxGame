package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;

	/**
	 * @author ...
	 */
	public class CorpsLevelRankItem 
	{
		public var id:uint;
		public var name:String;
		public var tuanzhang:String;
		public var level:uint;
		
		public var mNo:uint;		// 客户端自己使用序号

		public function deserialize(byte:ByteArray):void 
		{
			id = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			tuanzhang = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			level = byte.readUnsignedShort();
		}
	}
}

//struct CorpsLevelRankItem {
	//DWORD id;
	//char name[MAX_NAMESIZE];
	//char tuanzhang[MAX_NAMESIZE];
	//WORD level;
//};