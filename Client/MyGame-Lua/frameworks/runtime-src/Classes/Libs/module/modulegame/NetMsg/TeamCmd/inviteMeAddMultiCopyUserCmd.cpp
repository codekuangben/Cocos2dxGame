package game.netmsg.teamcmd
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;

	public class inviteMeAddMultiCopyUserCmd extends stCopyUserCmd
	{
		public var name:String;
		public var copyname:String;
		public var copytempid:uint;
		
		public function inviteMeAddMultiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.INVITE_ME_ADD_MULTI_COPY_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			copyname = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			copytempid = byte.readUnsignedInt();
		}
	}
}

//被邀请者收到的邀请信息 s->c
//const BYTE INVITE_ME_ADD_MULTI_COPY_USERCMD = 43;
//struct inviteMeAddMultiCopyUserCmd : public stCopyUserCmd
//{
//	inviteMeAddMultiCopyUserCmd()
//	{
//		byParam = INVITE_ME_ADD_MULTI_COPY_USERCMD;
//		bzero(name, MAX_NAMESIZE);
//		bzero(copyname, MAX_NAMESIZE);
//		copytempid = 0;
//	}
//	char name[MAX_NAMESIZE]; //邀请者名字
//	char copyname[MAX_NAMESIZE]; //副本名字
//	DWORD copytempid;
//};