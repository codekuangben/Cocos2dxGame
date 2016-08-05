package modulecommon.net.msg.teamUserCmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;

	public class TeamUser
	{
		public var id:uint;
		public var name:String;
		public var corps:String;
		public var zhanli:uint;
		public var sex:uint;
		public var job:uint;
		public var level:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			corps = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			zhanli = byte.readUnsignedInt();
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			level = byte.readUnsignedByte();
			
			//if(job > 3 || job < 1 || sex > 2 || sex < 1)
			//{
			//	trace("aaaaa");
			//}
		}
	}
}

//struct TeamUser {
//	TeamUser( void ):id(0),zhanli(0),sex(0),job(0) {
//		bzero(name, MAX_NAMESIZE);
//		bzero(corps, MAX_NAMESIZE);
//	}
//	TeamUser( DWORD _id, char* _name , char* _corps, DWORD _zhanli, BYTE _sex, BYTE _job );
//	DWORD id;
//	char name[MAX_NAMESIZE];
//	char corps[MAX_NAMESIZE];
//	DWORD zhanli;
//	BYTE sex;
//	BYTE job;
//  BYTE level;
//};