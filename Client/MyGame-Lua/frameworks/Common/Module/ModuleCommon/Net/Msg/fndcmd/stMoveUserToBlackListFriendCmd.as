package modulecommon.net.msg.fndcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;

	public class stMoveUserToBlackListFriendCmd extends stFriendCmd
	{
		public var name:String;
		public var result:uint;

		public function stMoveUserToBlackListFriendCmd()
		{
			super();
			byParam = PARA_MOVE_USER_TO_BLACKLIST_FRIENDCMD;	
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			result = byte.readUnsignedByte();
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
			byte.writeByte(result);
		}
	}
}

//将拉黑玩家(通过名字)
//const BYTE PARA_MOVE_USER_TO_BLACKLIST_FRIENDCMD = 23; 
//struct stMoveUserToBlackListFriendCmd : public stFriendCmd
//{   
//	stMoveUserToBlackListFriendCmd()
//	{   
//		byParam = PARA_MOVE_USER_TO_BLACKLIST_FRIENDCMD;
//		bzero(name,sizeof(name));
//	}   
//	char name[MAX_NAMESIZE];
//	BYTE result;    //0失败 1成功
//};