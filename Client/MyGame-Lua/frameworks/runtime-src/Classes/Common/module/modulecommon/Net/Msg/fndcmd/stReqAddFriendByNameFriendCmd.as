package modulecommon.net.msg.fndcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stReqAddFriendByNameFriendCmd extends stFriendCmd
	{
		public var num:uint;
		public var name:Vector.<String>;
		
		public function stReqAddFriendByNameFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_REQ_ADD_FRIEND_BY_NAME_FRIENDCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeShort(num);
			var idx:uint = 0;
			while(idx < num)
			{
				UtilTools.writeStr(byte, name[idx], EnNet.MAX_NAMESIZE);
				++idx;
			}
		}
	}
}

//请求加好友(通过名字加)
//const BYTE PARA_REQ_ADD_FRIEND_BY_NAME_FRIENDCMD = 5;
//struct stReqAddFriendByNameFriendCmd : public stFriendCmd
//{
//	stReqAddFriendByNameFriendCmd()
//	{
//		byParam = PARA_REQ_ADD_FRIEND_BY_NAME_FRIENDCMD;
//		num = 0;
//	}
//	WORD num;
//	char name[0];	
//};