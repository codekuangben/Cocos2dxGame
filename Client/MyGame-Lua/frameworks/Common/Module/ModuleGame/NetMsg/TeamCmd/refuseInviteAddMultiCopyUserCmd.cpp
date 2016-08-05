package game.netmsg.teamcmd
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import com.util.UtilTools;

	public class refuseInviteAddMultiCopyUserCmd extends stCopyUserCmd
	{
		public var name:String;

		public function refuseInviteAddMultiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REFUSE_INVITE_ADD_MULTI_COPY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
		}
	}
}

//被邀请者拒绝加入 c->s //如果被邀请者同意的话发41号消息
//const BYTE REFUSE_INVITE_ADD_MULTI_COPY_USERCMD = 43;
//struct refuseInviteAddMultiCopyUserCmd : public stCopyUserCmd
//{
//	refuseInviteAddMultiCopyUserCmd()
//	{
//		byParam = REFUSE_INVITE_ADD_MULTI_COPY_USERCMD;
//		bzero(name, MAX_NAMESIZE);
//	}
//	char name[MAX_NAMESIZE]; //邀请者名字
//};