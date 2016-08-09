package modulecommon.net.msg.guanZhiJingJiCmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	
	public class CharItem
	{
		public var tempid:uint;
		public var name:String;
		public var rank:uint;
		public var job:uint;
		public var sex:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			tempid = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			rank = byte.readUnsignedInt();
			job = byte.readUnsignedByte();
			sex = byte.readUnsignedByte();
		}
	}
}

//struct CharItem
//{   
//	DWORD tempid;
//	char name[MAX_NAMESIZE];
//	DWORD rank;			// 0 : 没有进入排行榜  非 0 就是进入排行榜的真正明次
//	BYTE job;
//	BYTE sex;
//};