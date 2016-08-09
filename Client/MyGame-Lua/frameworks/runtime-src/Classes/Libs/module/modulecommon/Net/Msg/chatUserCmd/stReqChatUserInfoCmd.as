package modulecommon.net.msg.chatUserCmd
{
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	import common.net.endata.EnNet;

	public class stReqChatUserInfoCmd extends stChatUserCmd
	{
		public var name:String;

		public function stReqChatUserInfoCmd()
		{
			super();
			byParam = stChatUserCmd.PARA_REQ_CHAT_USERINFO_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
		}
	}
}

//const BYTE PARA_REQ_CHAT_USERINFO_USERCMD = 5;
//struct stReqChatUserInfoCmd : public stChatUserCmd
//{   
//	stReqChatUserInfoCmd()
//	{   
//		byParam = PARA_REQ_CHAT_USERINFO_USERCMD;
//		bzero(name,sizeof(name));
//	}   
//	char name[MAX_NAMESIZE];
//};