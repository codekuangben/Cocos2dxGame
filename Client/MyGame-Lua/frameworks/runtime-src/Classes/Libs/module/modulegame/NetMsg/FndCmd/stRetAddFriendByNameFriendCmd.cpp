package game.netmsg.fndcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stRetAddFriendByNameFriendCmd extends stFriendCmd
	{
		public var result:uint;
		public var name:String;
		
		public function stRetAddFriendByNameFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_RET_ADD_FRIEND_BY_NAME_FRIENDCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			result = byte.readUnsignedByte();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
		}
	}
}

//通过名字加好友反馈
//const BYTE PARA_RET_ADD_FRIEND_BY_NAME_FRIENDCMD = 6;
//struct stRetAddFriendByNameFriendCmd : public stFriendCmd
//{
//	stRetAddFriendByNameFriendCmd()
//	{
//		byParam = PARA_RET_ADD_FRIEND_BY_NAME_FRIENDCMD;
//		result = 0;
//		bzero(name,sizeof(name));
//	}
//	BYTE result;	//0-失败 1-成功
//	char name[MAX_NAMESIZE];
//};