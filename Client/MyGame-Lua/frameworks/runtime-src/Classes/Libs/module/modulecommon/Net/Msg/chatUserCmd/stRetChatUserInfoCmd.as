package modulecommon.net.msg.chatUserCmd
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;

	public class stRetChatUserInfoCmd extends stChatUserCmd
	{
		public var name:String;
		public var sex:uint;
		public var charid:uint;
		public var job:uint;
		public var level:uint;

		public function stRetChatUserInfoCmd()
		{
			super();
			byParam = stChatUserCmd.PARA_RET_CHAT_USERINFO_USERCMD;
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
		
		public function getBaseInfo():stUserChatBaseInfoCmd
		{
			var baseinfo:stUserChatBaseInfoCmd = new stUserChatBaseInfoCmd();
			baseinfo.name = name;
			baseinfo.sex = sex;
			baseinfo.charid = charid;
			baseinfo.job = job;
			baseinfo.level = level;
			
			return baseinfo;
		}
	}
}

//const BYTE PARA_RET_CHAT_USERINFO_USERCMD = 6;
//struct stRetChatUserInfoCmd : public stChatUserCmd
//{   
//	stRetChatUserInfoCmd()
//	{   
//		byParam = PARA_RET_CHAT_USERINFO_USERCMD;
//		bzero(name,sizeof(name));
//		charid = 0;
//		sex = job = 0;
//		level = 0;
//	}
//	char name[MAX_NAMESIZE];
//	DWORD charid;
//	BYTE sex;
//	BYTE job;
//	WORD level;
//};