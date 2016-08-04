package game.netmsg.corpscmd
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.corpscmd.stCorpsCmd;
	import common.net.endata.EnNet;

	public class retInviteUserJoinCorpsUserCmd extends stCorpsCmd
	{
		public var name:String;
		public var corpsname:String;
		
		public function retInviteUserJoinCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.RET_INVITE_USER_JOIN_CORPS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			corpsname = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
		}
	}
}

//返回请求加入军团 s->c
//const BYTE RET_INVITE_USER_JOIN_CORPS_USERCMD = 51; 
//struct retInviteUserJoinCorpsUserCmd : public stCorpsCmd
//{   
//	retInviteUserJoinCorpsUserCmd()
//	{   
//		byParam = RET_INVITE_USER_JOIN_CORPS_USERCMD;
//		bzero(name, MAX_NAMESIZE);
//		bzero(corpsname, MAX_NAMESIZE);
//	}   
//	char name[MAX_NAMESIZE]; //邀请者名字
//	char corpsname[MAX_NAMESIZE];
//};