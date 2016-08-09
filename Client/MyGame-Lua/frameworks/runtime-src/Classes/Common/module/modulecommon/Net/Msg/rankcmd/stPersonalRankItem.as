package modulecommon.net.msg.rankcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author ...
	 */
	public class stPersonalRankItem
	{
		// 如果是自己的信息只有 rank 和 charid 赋值，其它的字段不赋值
		public var rank:uint;
		public var charid:uint;
		public var name:String;
		public var job:uint;
		public var level:uint;
		public var zhanli:uint;
		public var corpsname:String;
		
		public function deserialize(byte:ByteArray):void 
		{
			rank = byte.readUnsignedShort();
			charid = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			job = byte.readUnsignedByte();
			level = byte.readUnsignedShort();
			zhanli = byte.readUnsignedInt();
			corpsname = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
		}
	}
}

//struct stPersonalRankItem
//{
	//WORD rank;
	//DWORD charid;
	//char name[MAX_NAMESIZE];
	//BYTE job;
	//WORD level;
	//DWORD zhanli;
	//char corpsname[MAX_NAMESIZE];
//};