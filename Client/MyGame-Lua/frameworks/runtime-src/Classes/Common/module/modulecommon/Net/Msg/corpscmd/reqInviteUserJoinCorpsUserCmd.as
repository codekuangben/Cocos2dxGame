package modulecommon.net.msg.corpscmd
{
	import flash.utils.ByteArray;

	public class reqInviteUserJoinCorpsUserCmd extends stCorpsCmd
	{
		public var dwUserID:uint;

		public function reqInviteUserJoinCorpsUserCmd()
		{
			super();
			byParam = stCorpsCmd.REQ_INVITE_USER_JOIN_CORPS_USERCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(dwUserID);
		}
	}
}

//邀请加入军团 c->s
//const BYTE REQ_INVITE_USER_JOIN_CORPS_USERCMD = 50; 
//struct reqInviteUserJoinCorpsUserCmd : public stCorpsCmd
//{   
//	reqInviteUserJoinCorpsUserCmd()
//	{   
//		byParam = REQ_INVITE_USER_JOIN_CORPS_USERCMD;
//		dwUserID = 0;
//	}   
//	DWORD dwUserID; //被邀请者charid
//};