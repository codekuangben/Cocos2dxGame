package game.ui.uiTeamFBSys.msg
{
	import flash.utils.ByteArray;
	
	import common.net.endata.EnNet;
	import modulecommon.net.msg.copyUserCmd.stCopyUserCmd;
	import com.util.UtilTools;

	public class reqInviteOtherAddMultiCopyUserCmd extends stCopyUserCmd
	{
		public var name:String;

		public function reqInviteOtherAddMultiCopyUserCmd()
		{
			super();
			byParam = stCopyUserCmd.REQ_INVITE_OTHER_ADD_MULTI_COPY_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, name, EnNet.MAX_NAMESIZE);
		}
	}
}

//邀请别人加入多人副本 c->s
//const BYTE REQ_INVITE_OTHER_ADD_MULTI_COPY_USERCMD = 42;
//struct reqInviteOtherAddMultiCopyUserCmd : public stCopyUserCmd
//{
//	reqInviteOtherAddMultiCopyUserCmd()
//	{
//		byParam = REQ_INVITE_OTHER_ADD_MULTI_COPY_USERCMD;
//		bzero(name, MAX_NAMESIZE);
//	}
//	char name[MAX_NAMESIZE]; //被邀请者名字
//};