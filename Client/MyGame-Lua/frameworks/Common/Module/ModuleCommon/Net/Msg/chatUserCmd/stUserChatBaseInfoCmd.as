package modulecommon.net.msg.chatUserCmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;

	public class stUserChatBaseInfoCmd extends stChatUserCmd
	{
		public var name:String;
		public var sex:uint;
		public var charid:uint;
		public var job:uint;
		public var level:uint;
		
		public var chatlst:Array;			// 这个就是一个聊天列表
		
		public function stUserChatBaseInfoCmd()
		{
			super();
			byParam = stChatUserCmd.PARA_USER_CHAT_BASEINFO_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			charid = byte.readUnsignedInt();
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			level = byte.readUnsignedShort();
		}
		
		public function copyFrom(rhs:stUserChatBaseInfoCmd):void
		{
			this.name = rhs.name;
			this.sex = rhs.sex;
			this.charid = rhs.charid;
			this.job = rhs.job;
			this.level = rhs.level;
		}
	}
}

//const BYTE PARA_USER_CHAT_BASEINFO_USERCMD = 4;
//struct stUserChatBaseInfoCmd : public stChatUserCmd
//{   
//	stUserChatBaseInfoCmd()
//	{   
//		byParam = PARA_USER_CHAT_BASEINFO_USERCMD;
//		bzero(name,sizeof(name));
//		sex = job = 0;
//		level = 0;
//	}   
//	char name[MAX_NAMESIZE];
//	DWORD charid;
//	BYTE sex;
//	BYTE job;
//	WORD level;
//};